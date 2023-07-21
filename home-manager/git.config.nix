{ ... }:

{
  programs.git.enable = true;
  programs.git.userName = "Kaoticz";
  programs.git.userEmail = "1812311+Kaoticz@users.noreply.github.com";
  programs.git.signing.signByDefault = true;
  programs.git.signing.key = "D15F5CC9DEB319EB";
  # programs.git.signing.gpgPath = "/usr/bin/gpg"; # I can't install GnuPG through Nix because the GNOME shell requires it.
}
