{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${builtins.getEnv "USER"}";
  home.homeDirectory = "${builtins.getEnv "HOME"}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Importing Modules
  imports = [
    ./bash.config.nix
    ./firefox.config.nix
    ./git.config.nix
    ./vscode.config.nix
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    blesh # ble.sh (required by bash.config.nix)
    dotnet-sdk_7 # .NET 7
    nixpkgs-fmt # Nix code formatter
    shellcheck # Bash analyzer
  ];
}
