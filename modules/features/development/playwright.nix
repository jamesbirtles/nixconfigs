{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.development.playwright;

  # What nixpkgs built: a link farm of <name>-<revision> entries.
  built = pkgs.playwright-driver.browsers;

  # Same source of truth nixpkgs' own playwright expression uses, so the
  # aliases track whatever revisions the current nixpkgs actually built.
  revisions = (lib.importJSON "${pkgs.path}/pkgs/development/web/playwright/browsers.json").browsers;

  # Playwright locates a browser by stat'ing
  #   $PLAYWRIGHT_BROWSERS_PATH/<name>-<revision>/<layout>/<exe>
  # and performs no version check whatsoever. Pointing every plausible revision
  # at the one build we have removes the drift between a project's pinned
  # revision and nixpkgs' release cadence.
  #
  # 1200 is the chromium revision playwright 1.57 pinned, the release that
  # switched to Chrome-for-Testing and so to the chrome-linux64 layout nixpkgs
  # ships. Earlier playwright expects chrome-linux and is deliberately
  # unsupported. Revisions advance ~70/year, so 2000 lasts until ~2037.
  firstChromium = 1200;
  lastRevision = 2000;

  aliased = [
    {
      name = "chromium";
      inherit (revisions.chromium) revision;
      from = firstChromium;
    }
    {
      name = "chromium_headless_shell";
      inherit (revisions.chromium-headless-shell) revision;
      from = firstChromium;
    }
    {
      name = "ffmpeg";
      inherit (revisions.ffmpeg) revision;
      from = 1000;
    }
  ];

  # Playwright releases whose exact browser builds are linked, keyed by version.
  # The value is the hash of that tag of pietdevries94/playwright-web-flake:
  #   nix flake prefetch github:pietdevries94/playwright-web-flake/<version>
  pins = {
    "1.61.1" = "sha256-AzOBBjIPYL/QLoegOYhGv0KtIWjFq0P2AqioCJNABro=";
    "1.63.0" = "sha256-9hzGTpa8AMvhABSRnEeOYLn9vnzF157LYmSnsMdG5o8=";
    "1.64.1" = "sha256-2vH1lrj6Fv10Gaoun/tho8dz+1HmN6IFtwC5MMT9Gug=";
    "1.65.0" = "sha256-2xoQ4g1S4LCQDataLHqnPfjK2/mrFRWj/81O0BREra4=";
  };

  pinned = lib.mapAttrsToList (
    version: sha256:
    let
      src = builtins.fetchTarball {
        url = "https://github.com/pietdevries94/playwright-web-flake/archive/refs/tags/${version}.tar.gz";
        inherit sha256;
      };
    in
    (pkgs.callPackage "${src}/playwright-driver/driver.nix" { }).playwright-core
  ) pins;

  # Genuine builds, each at the revision its playwright release pinned:
  # nixpkgs' own plus one set per pin. They take precedence over the aliases,
  # and are the only firefox and webkit entries: those are playwright-patched
  # forks, where a wrong revision fails on protocol mismatches and a missing
  # one fails clearly.
  exact = lib.mergeAttrsList (
    map (driver: driver.browsers.entries) (pinned ++ [ pkgs.playwright-driver ])
  );

  aliases = lib.listToAttrs (
    lib.concatMap (
      b:
      map (
        revision: lib.nameValuePair "${b.name}-${toString revision}" "${built}/${b.name}-${b.revision}"
      ) (lib.range b.from lastRevision)
    ) aliased
  );

  registry = pkgs.linkFarm "playwright-browsers-aliased" (aliases // exact);
in
{
  options.features.development.playwright = {
    enable = lib.mkEnableOption "Playwright browsers, aliased across every revision";
  };

  config = lib.mkIf cfg.enable {
    environment.sessionVariables = {
      PLAYWRIGHT_BROWSERS_PATH = "${registry}";
      PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
      # The registry is a read-only store path and is already complete, so
      # postinstall downloads and stale-browser collection are both no-ops.
      PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
      PLAYWRIGHT_SKIP_BROWSER_GC = "1";
    };
  };
}
