{ config, lib, pkgs, outPath ? null, ... }:
{
  imports = [
    ./nix.nix
    ./users.nix
    ./locale.nix
    ./networking.nix
  ];

  # Kernel version
  boot.kernelPackages = pkgs.linuxPackages_6_17;

  # Shell aliases
  environment.shellAliases = {
    nb = "sudo nixos-rebuild switch --flake .#";
    nu = "nix flake update --commit-lock-file";
    nix-repair = "sudo nix-store --repair --verify --check-contents";
    kit = "zellij --layout sveltekit";
    mkit = "zellij --layout sveltekit-mini";
  };

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    fira-code
    fira-code-symbols
  ];

  # Environment variables
  environment.sessionVariables = {
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };

  # PAM login limits
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "65536";
    }
  ];

  # Core system packages
  environment.systemPackages = with pkgs; [
    # Infrastructure/cloud tools
    hcloud
    vultr-cli
    infisical

    # Development environment
    devenv

    # Utilities
    jq
    rclone
    claude-code
    prisma

    # Nix development tools
    nil
    nixd

    # Python and playwright
    python3
    python3Packages.playwright

    # Media tools
    ffmpeg
    tsduck
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-rs
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi

    # Helper scripts
    (pkgs.writeShellScriptBin "check-updates" ''
      # Default values
      FLAKE_DIR="${if outPath != null then outPath else "$HOME/nixconfigs"}"
      IGNORE_INPUTS=""

      # Parse arguments
      while [[ $# -gt 0 ]]; do
        case $1 in
          --ignore)
            IGNORE_INPUTS="$2"
            shift 2
            ;;
          --flake-dir)
            FLAKE_DIR="$2"
            shift 2
            ;;
          *)
            FLAKE_DIR="$1"
            shift
            ;;
        esac
      done

      if [ ! -f "$FLAKE_DIR/flake.nix" ]; then
        echo "Error: Cannot find flake.nix at $FLAKE_DIR"
        exit 1
      fi

      # Get all direct inputs
      ${pkgs.nix}/bin/nix flake metadata "$FLAKE_DIR" --json | ${pkgs.jq}/bin/jq -r '
        .locks.nodes.root.inputs |
        to_entries[] |
        .key as $name |
        .value as $node |
        "\($name) \($node)"
      ' | while read -r name node; do
        # Check if this input should be ignored
        if echo " $IGNORE_INPUTS " | grep -q " $name "; then
          continue
        fi

        # Get the locked node info
        locked=$(${pkgs.nix}/bin/nix flake metadata "$FLAKE_DIR" --json | ${pkgs.jq}/bin/jq -r ".locks.nodes.\"$node\"")

        # Build the original reference
        original=$(echo "$locked" | ${pkgs.jq}/bin/jq -r '
          if .original.type == "github" then
            "github:\(.original.owner)/\(.original.repo)" + (if .original.ref then "/\(.original.ref)" else "" end)
          elif .original.type == "indirect" then
            .original.id
          else
            .original.url // empty
          end
        ')

        if [ -z "$original" ] || [ "$original" = "null" ]; then
          continue
        fi

        # Get fingerprints
        current=$(echo "$locked" | ${pkgs.jq}/bin/jq -r '.locked.narHash // empty')
        latest=$(${pkgs.nix}/bin/nix flake metadata "$original" --refresh --json 2>/dev/null | ${pkgs.jq}/bin/jq -r '.locked.narHash // empty')

        if [ -n "$current" ] && [ -n "$latest" ] && [ "$current" != "$latest" ]; then
          echo "$name $current -> $latest"
        fi
      done
    '')

    (pkgs.writeShellScriptBin "update-system" ''
      set -e

      echo "Updating system from: $HOME/nixconfigs"
      cd "$HOME/nixconfigs"

      # Update flake
      echo "Running nix flake update..."
      nix flake update --commit-lock-file

      # Build the system
      echo "Building system..."
      sudo nixos-rebuild switch --flake .#

      # Push if build succeeded
      echo "Build successful, pushing..."
      ${pkgs.git}/bin/git push

      echo "Done!"
      echo "Press enter to exit"
      read
    '')
  ];
}
