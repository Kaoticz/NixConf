{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Kaoticz";
    userEmail = "1812311+Kaoticz@users.noreply.github.com";
    signing.signByDefault = true;
    signing.key = "D15F5CC9DEB319EB";
    # signing.gpgPath = "/usr/bin/gpg"; # Use this if you can't install GnuPG through Nix.
  };
}