# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  # Import Modules
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.
    ./Modules/all-modules.config.nix #
  ];

  ### Configurables ###

  # Kernel Version.
  boot.kernelPackages = pkgs.linuxPackages_latest.extend (self: super: {
    kernel = super.kernel // pkgs.linuxKernel.kernels.linux_zen; # Linux Zen Kernel
  });

  # Enable GnuPG.
  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;
  programs.gnupg.agent.pinentryFlavor = "gnome3";

  # Enable Flatpaks.
  services.flatpak.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Others.
  services.printing.enable = false; # Enable CUPS to print documents.
  services.openssh.enable = false; # Enable OpenSSH.
  kotz.virtualization.docker.enable = true; # Enable Docker.
  kotz.graphics.de.pantheon.enable = true; # Enable Pantheon Desktop Environment.
  kotz.audio.pipewire.enable = true; # Enable Pipewire.
  kotz.drivers.spice.enable = true; # Enable KVM drivers.
  kotz.networking.enable = true; # Enable personal networking settings.
  kotz.boot.grub.enable = true; # Enable Grub.
  kotz.locale.enable = true; # Enable personal locale settings.
  kotz.user.enable = true; # Enable Kotz's personal settings.

  ### Extra Packages ###

  environment.systemPackages = with pkgs; [
    tldr # Quick documentation
    neofetch # Prints system information to the console
    appimage-run # Needed to execute AppImages
  ];

  ### Don't Touch Unless You Know What You're Doing ###

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

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
  system.stateVersion =
    builtins.replaceStrings [ "\n" " " ] [ "" "" ]
      (builtins.readFile ./Config/nixos-version);
}
