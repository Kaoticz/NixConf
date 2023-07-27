# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    # Dependencies
    ./Modules/Dependencies/nur.config.nix # Nix User Repository

    # Core Settings
    ./hardware-configuration.nix # Include the results of the hardware scan.
    ./Modules/Core/Boot/grub.config.nix # GRUB Bootloader
    ./Modules/Core/Misc/locale.config.nix # Localization settings
    ./Modules/Core/Misc/network.config.nix # Networking settings
    ./Modules/Core/Audio/pipewire.config.nix # Pipewire
    ./Modules/Core/Graphics/DEs/pantheon.config.nix # Pantheon Desktop Environment

    # Driver Settings
    ./Modules/Core/Drivers/spice.config.nix # Spice-Agent Drivers

    # App Settings
    ./Modules/Apps/docker.config.nix # Docker

    # User Settings
    ./Modules/Users/kotz.config.nix
  ];

  # Packages to install system-wide.
  environment.systemPackages = with pkgs; [
    tldr # Quick documentation
    neofetch # Prints system information on the console
    appimage-run # Needed to execute AppImages
  ];

  # Kernel Version
  boot.kernelPackages = pkgs.linuxPackages_latest.extend (self: super: {
    kernel = super.kernel // pkgs.linuxKernel.kernels.linux_zen; # Linux Zen Kernel
  });

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable the OpenSSH daemon.
  services.openssh.enable = false;

  # Enable Flatpaks
  services.flatpak.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Enable GnuPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  #
  # This reads from a file named "nixos-version", whose contents comprise entirely of the
  # version of NixOS that was originally installed. Example: 23.05
  # This file is automatically created when first_setup.sh is run.
  system.stateVersion = builtins.replaceStrings [ "\n" " " ] [ "" "" ] (builtins.readFile ./Config/nixos-version);
}
