{ pkgs, ... }:

{
  imports = [
    ../Windowing/X11.config.nix
  ];

  # Enable the Pantheon Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.pantheon.enable = true;

  # Enable Pantheon Tweaks
  programs.pantheon-tweaks.enable = true;

  # Add extra packages
  environment.systemPackages = with pkgs; [
    whitesur-gtk-theme
    gnome.gnome-system-monitor
    gnome.gnome-calculator
  ];

  # Exclude some Pantheon packages
  environment.pantheon.excludePackages = with pkgs; [
    pantheon.epiphany
    pantheon.elementary-tasks
    pantheon.elementary-camera
    pantheon.elementary-calculator
  ];
}
