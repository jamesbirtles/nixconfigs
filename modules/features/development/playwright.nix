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

  # Playwright-patched forks, passed through at their genuine revisions only: a
  # wrong-revision firefox or webkit misbehaves confusingly, where a missing one
  # fails clearly.
  exact = [
    {
      name = "firefox";
      inherit (revisions.firefox) revision;
    }
    {
      name = "webkit";
      inherit (revisions.webkit) revision;
    }
  ];

  link = name: revision: real: {
    name = "${name}-${toString revision}";
    path = "${built}/${name}-${real}";
  };

  registry = pkgs.linkFarm "playwright-browsers-aliased" (
    map (b: link b.name b.revision b.revision) exact
    ++ lib.concatMap (
      b: map (revision: link b.name revision b.revision) (lib.range b.from lastRevision)
    ) aliased
  );
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
