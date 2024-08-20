# Common programs used across platforms
{ pkgs, lib, ... }:
let
  zellijAutoCompletion = pkgs.runCommand "zellij-completion" {} ''
    mkdir -p $out
    ${pkgs.zellij}/bin/zellij setup --generate-completion zsh | sed -Ee 's/^(_(zellij) ).*/compdef \1\2/' > $out/zellij-autocomplete.plugin.zsh 
  '';
in
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "raycast"
    "discord"
  ];
  home-manager.users.james = {
    home.packages = with pkgs; [
      discord
    ];

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      plugins = [
        {
          name = "zellij-autocomplete";
          src = zellijAutoCompletion;
        }
      ];
    };
    programs.oh-my-posh = {
      enable = true;
      useTheme = "half-life";
    };
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    programs.alacritty = {
      enable = true;
      settings = {
        import = [ "${pkgs.alacritty-theme}/ayu_dark.toml" ];
        window = {
          opacity = 1;
          blur = true;
          option_as_alt = "Both";
        };
        font = {
          size = lib.mkDefault 13;
          normal = { family = "BerkeleyMonoVariable Nerd Font Mono"; style = "Regular"; };
        };
        colors = {
          transparent_background_colors = true;
        };
      };
    };

    programs.git = {
      enable = true;
      userEmail = "james@birtles.dev";
      userName = "James Birtles";
      signing = {
        signByDefault = true;
        key = null;
      };
      extraConfig = {
        push.autoSetupRemote = true;
        init.defaultBranch = "main";
      };
      ignores = [
        ".DS_Store"
        "Desktop.ini"
        ".Spotlight-V100"
        ".Trashes"
      ];
    };

    programs.lazygit = {
      enable = true;
      settings.gui.showFileTree = false;
    };

    programs.zellij = {
      enable = true;
      enableZshIntegration = false;
    };
    xdg.configFile."zellij/config.kdl".text = ''
      keybinds {
        shared_except "locked" {
          unbind "Ctrl g" // was Lock, now Alt-g
          unbind "Ctrl p" // was Pane, now Alt-p
          unbind "Ctrl t" // was Tab, now Alt-t
          unbind "Ctrl n" // was Resize, now Alt-n
          unbind "Ctrl h" // was Move, now Alt-m
          unbind "Ctrl s" // was Search, now Alt-s
          unbind "Ctrl o" // was Session, now Alt-o
          unbind "Ctrl q" // was Quit, now Alt-q
          bind "Alt g" { SwitchToMode "locked"; }
          bind "Alt q" { Quit; }
        }
        locked {
          bind "Alt g" { SwitchToMode "Normal"; }
        }

        shared_except "pane" "locked" {
          bind "Alt p" { SwitchToMode "pane"; }
        }
        pane {
          bind "Alt p" { SwitchToMode "Normal"; }
          bind "h" { NewPane "left"; }
          bind "j" { NewPane "down"; }
          bind "k" { NewPane "up"; }
          bind "l" { NewPane "right"; }
        }

        shared_except "tab" "locked" {
          bind "Alt t" { SwitchToMode "tab"; }
        }
        tab {
          bind "Alt t" { SwitchToMode "Normal"; }
        }

        shared_except "resize" "locked" {
          bind "Alt n" { SwitchToMode "resize"; }
        }
        resize {
          bind "Alt n" { SwitchToMode "Normal"; }
        }

        shared_except "move" "locked" {
          bind "Alt m" { SwitchToMode "move"; }
        }
        move {
          bind "Alt m" { SwitchToMode "Normal"; }
        }

        shared_except "search" "locked" {
          bind "Alt s" { SwitchToMode "search"; }
        }
        search {
          bind "Alt s" { SwitchToMode "Normal"; }
        }

        shared_except "session" "locked" {
          bind "Alt o" { SwitchToMode "session"; }
        }
        session {
          bind "Alt o" { SwitchToMode "Normal"; }
        }
      }
    '';
  };
}

