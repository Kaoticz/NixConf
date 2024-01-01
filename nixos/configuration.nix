# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  # Import Modules
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.
    ./Modules/all-modules.config.nix
  ];

  ### Configurables ###

  # Kernel Version.
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Enable zram
  zramSwap.enable = true;
  zramSwap.memoryPercent = 75;
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
  };

  # Environment Variables
  environment.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };

  # Enable GnuPG.
  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;
  programs.gnupg.agent.pinentryFlavor = "gnome3";

  # Enable Flatpaks.
  services.flatpak.enable = true;

  # Others.
  services.printing.enable = true; # Enable CUPS to print documents.
  services.openssh.enable = true; # Enable OpenSSH.
  kotz.graphics.de.pantheon.enableDisplayManager = true; # Enable LightDm with Pantheon's greeter.
  kotz.graphics.de.pantheon.enable = true; # Enable Pantheon Desktop Environment.
  kotz.virtualization.docker.enable = true; # Enable Docker.
  kotz.patching.nix-alien.enable = true; # Enable execution of unpatched binaries.
  kotz.audio.pipewire.enable = true; # Enable Pipewire.
  kotz.drivers.spice.enable = false; # Enable KVM guest drivers.
  kotz.networking.enable = true; # Enable personal networking settings.
  kotz.boot.grub.enable = true; # Enable Grub.
  kotz.locale.enable = true; # Enable personal locale settings.
  kotz.user.enable = true; # Enable Kotz's personal settings.

  ### Extra Packages ###

  environment.systemPackages = with pkgs; [
    appimage-run # Needed to execute AppImages
    neofetch # Prints system information to the console
    ripgrep # Quick grep
    tldr # Quick documentation
  ];

  ### Don't Touch Unless You Know What You're Doing ###

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
