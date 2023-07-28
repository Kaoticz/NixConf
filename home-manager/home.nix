{ pkgs, ... }:

{
  # Import Modules
  imports = [
    ./Modules/all-modules.config.nix
  ];

  # Shell
  kotz.bash.enable = true;
  kotz.bash.enableBlesh = true;
  kotz.bash.enableAliases = true;
  kotz.bash.environment = "pantheon";

  # Others
  kotz.vscode.enable = true; # VSCode
  kotz.git.enable = true; # Git
  kotz.firefox.enable = true; # Firefox

  # The home.packages option allows you to install Nix packages into your environment.
  home.packages = with pkgs; [
    tor-browser-bundle-bin # The Tor Browser
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  #
  # This reads from a file named "hm-version", whose contents comprise entirely of the
  # version of Home Manager that is being used. Example: 23.05
  # This file is automatically created when first_setup.sh is run.
  home.stateVersion =
    builtins.replaceStrings [ "\n" " " ] [ "" "" ]
      (builtins.readFile ./Config/hm-version);

  # This is a very basic attempt at activating .desktop files in non-NixOS systems.
  # A reboot may be necessary after installation.
  # /etc/os-release is not guaranteed to be in every Linux distribution.
  # If you are not using NixOS and programs installed through Nix are not getting an
  # entry in your desktop environment, just set this variable to 'true'.
  targets.genericLinux.enable =
    !builtins.elem "nixos"
      (builtins.match ".*\nID=([^\n]+).*"
        (builtins.readFile /etc/os-release));
}
