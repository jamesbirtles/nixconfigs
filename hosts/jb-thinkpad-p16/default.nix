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
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;

  system.stateVersion = "26.05";
}
