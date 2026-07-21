{
  config,
  lib,
  pkgs,
  lan-mouse,
  ...
}:
let
  cfg = config.features.services.lan-mouse;
in
{
  options.features.services.lan-mouse = {
    enable = lib.mkEnableOption "lan-mouse (Wayland-native software KVM)";

    port = lib.mkOption {
      type = lib.types.port;
      default = 4242;
      description = "Port lan-mouse listens on and reaches peers over.";
    };

    peers = lib.mkOption {
      description = "Neighbouring machines to share input with.";
      default = [ ];
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            hostname = lib.mkOption {
              type = lib.types.str;
              description = "Peer's `networking.hostName`, resolved via the system resolver.";
            };
            position = lib.mkOption {
              type = lib.types.enum [
                "left"
                "right"
                "top"
                "bottom"
              ];
              description = "Which edge of *this* machine's screen the peer sits on.";
            };
            ips = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "Optional static IPs, used instead of resolving the hostname.";
            };
            fingerprint = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                Peer's TLS certificate fingerprint, authorizing it to connect.
                Read it off the peer once its daemon has run (`lan-mouse` GUI, or
                the `cert.pem` fingerprint), then set it here. Left null until then.
              '';
            };
          };
        }
      );
    };
  };

  config = lib.mkIf cfg.enable {
    # lan-mouse's transport is DTLS-over-UDP, so only UDP needs opening.
    networking.firewall.allowedUDPPorts = [ cfg.port ];

    home-manager.users.james = {
      imports = [ lan-mouse.homeManagerModules.default ];

      programs.lan-mouse = {
        enable = true;
        settings = {
          port = cfg.port;
          clients = map (
            peer:
            {
              inherit (peer) position hostname;
              activate_on_startup = true;
            }
            // lib.optionalAttrs (peer.ips != [ ]) { inherit (peer) ips; }
          ) cfg.peers;
          authorized_fingerprints = lib.listToAttrs (
            map (peer: lib.nameValuePair peer.fingerprint peer.hostname) (
              lib.filter (peer: peer.fingerprint != null) cfg.peers
            )
          );
        };
      };
    };
  };
}
