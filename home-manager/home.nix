{ pkgs, ... }:

{
  # Importing Modules
  imports = [
    ./Modules/Shells/Bash/bash.kotz.config.nix
    ./Modules/Web/firefox.config.nix
    ./Modules/Development/git.config.nix
    ./Modules/Development/vscode.config.nix
  ];

  kotz.bash.enable = true;
  kotz.bash.enableBlesh = true;
  kotz.bash.enableAliases = true;
  kotz.bash.environment = "pantheon";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    blesh # ble.sh (required by bash.config.nix)
    dotnet-sdk_7 # .NET 7
    exa # "ls" replacement
    nil # Nix LSP server
    nixpkgs-fmt # Nix code formatter
    shellcheck # Bash analyzer
    tor-browser-bundle-bin # The Tor Browser
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
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
  home.stateVersion = builtins.replaceStrings [ "\n" " " ] [ "" "" ] (builtins.readFile ./Config/hm-version);
}
