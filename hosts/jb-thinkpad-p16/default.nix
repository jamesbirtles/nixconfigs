{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ../../modules/core
    ../../modules/features
    ../../modules/profiles/work.nix
  ];

  networking.hostName = "jb-thinkpad-p16";

  features.hardware.fingerprint.enable = false;

  # NVIDIA — settings we own beyond the imported generic nixos-hardware modules.
  # The flake imports `common-gpu-nvidia-nonprime`, whose only contribution is
  # `services.xserver.videoDrivers = ["nvidia"]`. Despite the `xserver` name,
  # that is what the nvidia module keys off (nvidiaEnabled) to bring up the whole
  # stack — kernel modules, driver packages, hardware.graphics, modesetting — on
  # Wayland too; we run no X server but it is still required. We use the
  # *nonprime* variant (not `common-gpu-nvidia`, which forces PRIME offload on)
  # because the BIOS is in Discrete Graphics mode: the Intel iGPU is MUXed off,
  # so the NVIDIA GPU is the only one on the bus and there is nothing to offload to.
  hardware.nvidia = {
    # Load-bearing: it makes the driver expose its own framebuffer device, which
    # is what lets the GNOME Wayland session run on NVIDIA. Set explicitly even
    # though current drivers default it on. (The option's docs only mention the
    # proprietary driver, but it applies equally to the open modules — both ship
    # nvidia-drm and honour nvidia-drm.modeset=1.)
    modesetting.enable = true;

    # Use the open kernel modules: NVIDIA recommends and best-supports them for
    # this GPU's generation (Ada Lovelace / Turing+), and they let the driver use
    # kernel suspend notifiers for more robust suspend/resume. Must be set
    # explicitly — current drivers default this to null to force a choice.
    open = true;

    # Has the driver save and restore VRAM across suspend/resume, avoiding
    # corrupted state on resume. Off by default; wanted on a laptop.
    powerManagement.enable = true;

    # Lets the nvidia-powerd daemon shift the shared CPU/GPU power budget toward
    # whichever is the bottleneck under load, for better performance on supported
    # laptops (this one qualifies). Off by default.
    dynamicBoost.enable = true;

    # Keep clock-floor settings (below) alive without a running GPU context:
    # without persistence mode the driver tears down state when no client is
    # attached and the locked clocks reset.
    nvidiaPersistenced = true;
  };

  # Browser scroll stutter fix. After the GPU sits idle for a couple seconds it
  # drops into a deep low-power state; the first scroll forces an abrupt clock
  # ramp whose transition latency spikes a frame, making Chrome's smooth-scroll
  # animation overshoot and visibly jitter up/down before settling. Both clocks
  # must be floored to avoid this:
  #
  #   - Graphics clock (-lgc): idles down to ~210 MHz; floored at 510 MHz.
  #   - Memory clock (-lmc): idles down to 810 MHz, and that 810 -> 8001 MHz ramp
  #     is the larger contributor; floored at 6001 MHz.
  #
  # Upper bounds are the hardware max (3105 / 8001 MHz), so this is a floor only
  # and peak boost is unaffected.
  systemd.services.nvidia-clock-floor = {
    description = "Pin minimum NVIDIA GPU + memory clocks to avoid browser scroll stutter on idle->3D ramp";
    wantedBy = [ "multi-user.target" ];
    after = [ "nvidia-persistenced.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      # nvidia-smi only allows one device modification per invocation, so the
      # graphics and memory locks must be separate calls (oneshot runs them in
      # sequence).
      ExecStart = [
        "${config.hardware.nvidia.package.bin}/bin/nvidia-smi -lgc 510,3105"
        "${config.hardware.nvidia.package.bin}/bin/nvidia-smi -lmc 6001,8001"
      ];
      ExecStop = [
        "${config.hardware.nvidia.package.bin}/bin/nvidia-smi -rgc"
        "${config.hardware.nvidia.package.bin}/bin/nvidia-smi -rmc"
      ];
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;

  system.stateVersion = "26.05";
}
