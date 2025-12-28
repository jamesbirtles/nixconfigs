{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.security.sshd;
in
{
  options.features.security.sshd = {
    enable = lib.mkEnableOption "SSH server with secure settings";
  };

  config = lib.mkIf cfg.enable {
    # Enable OpenSSH daemon
    services.openssh = {
      enable = true;

      settings = {
        # Security settings
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;

        # Enable public key authentication
        PubkeyAuthentication = true;

        # Disable X11 forwarding for security
        X11Forwarding = false;

        # Use more secure key exchange algorithms
        KexAlgorithms = [
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
          "diffie-hellman-group-exchange-sha256"
        ];

        # Use more secure ciphers
        Ciphers = [
          "chacha20-poly1305@openssh.com"
          "aes256-gcm@openssh.com"
          "aes128-gcm@openssh.com"
          "aes256-ctr"
          "aes192-ctr"
          "aes128-ctr"
        ];

        # Use more secure MACs
        Macs = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
          "umac-128-etm@openssh.com"
        ];
      };
    };

    # Configure authorized keys for user james
    users.users.james.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOvUudGnuBJItRUSZen7D4Emkh1ZCA4C1t93Ke4A1yFr"
    ];

    # Open SSH port in firewall
    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
