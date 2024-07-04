{ lib, config, ... }:
let
  cfg = config.kotz.git;
in
{
  # Imports: extra modules this module uses.
  imports = [ ];

  # Options: settings the user can change.
  options.kotz.git = {
    enable = lib.mkEnableOption "Kotz's Git configuration.";
  };

  # Config: things that must be done if this module is enabled.
  config = lib.mkIf cfg.enable {
    programs.git.enable = true;
    programs.git.userName = "Kaoticz";
    programs.git.userEmail = "1812311+Kaoticz@users.noreply.github.com";
    programs.git.signing.key = "D15F5CC9DEB319EB";
    programs.git.signing.signByDefault = true;
    programs.git.extraConfig.pull.rebase = true;
    programs.git.extraConfig.rerere.enabled = true;
    programs.git.extraConfig.init.defaultbranch = "main";
    #programs.git.signing.gpgPath = "/usr/bin/gpg"; # Use this if you can't install GnuPG through Nix.
  };
}
