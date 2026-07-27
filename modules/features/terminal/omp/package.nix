# omp (Oh My Pi) ships prebuilt release binaries only — the source tree is a
# Bun + Rust workspace with git-lfs assets, which isn't worth reproducing here.
# Bump `version` and `hash` together when updating.
{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "omp";
  version = "17.1.3";

  src = fetchurl {
    url = "https://github.com/can1357/oh-my-pi/releases/download/v${finalAttrs.version}/omp-linux-x64";
    hash = "sha256-F6fi4cScvAkSnin79IzevRpUXQU/XK1ylcGJi26qQi4=";
  };

  dontUnpack = true;

  # Bun appends the JS/asset bundle after the ELF image. `strip` discards it and
  # the binary silently degrades into a bare `bun` REPL, so leave it intact.
  # Rewriting the interpreter with patchelf is safe.
  dontStrip = true;

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/omp
    runHook postInstall
  '';

  meta = {
    description = "Oh My Pi — terminal coding agent with LSP/DAP wired in";
    homepage = "https://omp.sh/";
    license = lib.licenses.mit;
    mainProgram = "omp";
    platforms = [ "x86_64-linux" ];
  };
})
