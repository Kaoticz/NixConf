# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    # Dependencies
    ./Modules/Dependencies/nur.config.nix     # Nix User Repository

    # Core Settings
    ./hardware-configuration.nix              # Include the results of the hardware scan.
    ./Modules/Core/Boot/grub.config.nix       # GRUB Bootloader
    ./Modules/Core/Misc/locale.config.nix     # Localization settings
    ./Modules/Core/Misc/network.config.nix    # Networking settings
    ./Modules/Core/Audio/pipewire.config.nix  # Pipewire
    ./Modules/Core/Graphics/DEs/pantheon.config.nix    # Pantheon Desktop Environment

    # Driver Settings
    ./Modules/Core/Drivers/spice.config.nix   # Spice-Agent Drivers

    # App Settings
    ./Modules/Apps/docker.config.nix          # Docker
    
    # User Settings
    ./Modules/Users/kotz.config.nix
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Kernel Version
  boot.kernelPackages = pkgs.linuxPackages_latest.extend (self: super: {
    kernel = super.kernel // pkgs.linuxKernel.kernels.linux_zen;  # Linux Zen Kernel
  });  

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Packages to install system-wide.
  environment.systemPackages = with pkgs; [
    tldr          # Quick documentation
    neofetch      # Prints sytem information on the console
    appimage-run  # Needed to execute AppImages
  ];

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
}
