{
  pkgs,
  zen-browser,
  outPath,
  ...
}:
{
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
    options = "caps:escape";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;
  services.desktopManager.gnome.enable = true;

  services.printing.enable = true;
  services.fwupd.enable = true;
  services.fprintd.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  console.keyMap = "uk";
  users.defaultUserShell = pkgs.zsh;

  programs.chromium.enable = true;
  programs.steam.enable = true;
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "james" ];
  };

  fonts.fontDir.enable = true;

  environment.systemPackages = with pkgs; [
    wl-clipboard
    dconf2nix
    mangohud
    gnomeExtensions.appindicator
    gnome-tweaks
    zen-browser
    protonup-qt
    parsec-bin
    prusa-slicer
    orca-slicer
    vscode.fhs
    playerctl
    thunderbird
    slack
    openconnect
    obsidian
    protonvpn-gui
    vlc
    (pkgs.kodi-wayland.withPackages (kodiPkgs: with kodiPkgs; [
		pvr-iptvsimple
	]))
    (pkgs.writeShellScriptBin "check-updates" ''
      # Default values
      FLAKE_DIR="${outPath}"
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
  services.udev.packages = [ pkgs.gnome-settings-daemon ];
  programs.gamemode.enable = true;
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  security.polkit.enable = true;

  # Allows zoom to find xdg-desktop-portal to allow for screensharing
  systemd.tmpfiles.rules = [
    "L+ /usr/libexec/xdg-desktop-portal - - - - ${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal"
  ];

  # In theory I could add something like this but would need to figure out storing the password
  # instead just configure it with `rclone config`
  # environment.etc."rclone-mnt.conf".text = ''
  #   [myremote]
  #   type = sftp
  #   host = 192.0.2.2
  #   user = myuser
  #   key_file = /root/.ssh/id_rsa
  # '';

  fileSystems."/home/james/ProtonDrive" = {
    device = "protondrive:";
    fsType = "rclone";
    options = [
      "nodev"
      "nofail"
      "allow_other"
      "args2env"
      "config=/home/james/.config/rclone/rclone.conf"
    ];
  };
}
