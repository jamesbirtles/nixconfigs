# Common programs used across platforms
{ pkgs, lib, ... }:
let
  zellijAutoCompletion = pkgs.runCommand "zellij-completion" {} ''
    mkdir -p $out
    ${pkgs.zellij}/bin/zellij setup --generate-completion zsh | sed -Ee 's/^(_(zellij) ).*/compdef \1\2/' > $out/zellij-autocomplete.plugin.zsh 
  '';
in
{
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
      general = {
        import = [ "${pkgs.alacritty-theme}/ayu_dark.toml" ];
      };
      window = {
        opacity = 1;
        blur = true;
        option_as_alt = "Both";
      };
      font = {
        size = lib.mkDefault 13;
        normal = { family = lib.mkDefault "BerkeleyMono Nerd Font"; style = "Regular"; };
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
      signByDefault = false;
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
  programs.gpg.enable = true;
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };

  programs.lazygit = {
    enable = true;
    settings.gui = {
      showFileTree = false;
      nerdFontsVersion = "3";
      theme.selectedLineBgColor = [ "reverse" ];
    };
  };
  programs.nnn.enable = true;

  programs.zoxide.enable = true;
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
  };
  programs.btop.enable = true;
  programs.ripgrep.enable = true;
  programs.fd.enable = true;
  programs.bat.enable = true;

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
        bind "Alt 1" { GoToTab 1; }
        bind "Alt 2" { GoToTab 2; }
        bind "Alt 3" { GoToTab 3; }
        bind "Alt 4" { GoToTab 4; }
        bind "Alt 5" { GoToTab 5; }
        bind "Alt 6" { GoToTab 6; }
        bind "Alt 7" { GoToTab 7; }
        bind "Alt 8" { GoToTab 8; }
        bind "Alt 9" { GoToTab 9; }
        bind "Alt 0" { GoToTab 10; }
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
  xdg.configFile."zellij/layouts/sveltekit.kdl".text = ''
    layout {
      default_tab_template {
        pane size=1 borderless=true {
          plugin location="zellij:tab-bar"
        }
        children
        pane size=2 borderless=true {
          plugin location="zellij:status-bar"
        }
      }
      tab name="Scratch" {
        pane split_direction="vertical" {
          pane
          pane
        }
        pane split_direction="vertical" {
          pane
          pane
        }
      }
      tab name="Main" focus=true {
        pane split_direction="vertical" {
          pane size=80 {
            pane name="Check" {
              command "npm"
              args "run" "check:watch"
            }
            pane name="Run" {
              command "devenv"
              args "up"
            }
          }
          pane {
            name "Editor"
            focus true
            command "vim"
          }
        }
      }
      tab name="Lazygit" {
        pane name="Lazygit" borderless=true {
          command "lazygit"
        }
      }
    }
  '';
  xdg.configFile."zellij/layouts/sveltekit-mini.kdl".text = ''
    layout {
      default_tab_template {
        pane size=1 borderless=true {
          plugin location="zellij:tab-bar"
        }
        children
        pane size=2 borderless=true {
          plugin location="zellij:status-bar"
        }
      }
      tab name="Processes" {
        pane split_direction="vertical" {
          pane name="Check" {
            command "npm"
            args "run" "check:watch"
          }
          pane name="Run" {
            command "devenv"
            args "up"
          }
        }
      }
      tab name="Main" focus=true {
        pane {
          name "Editor"
          focus true
          command "vim"
        }
      }
      tab name="Lazygit" {
        pane name="Lazygit" borderless=true {
          command "lazygit"
        }
      }
    }
  '';
}

