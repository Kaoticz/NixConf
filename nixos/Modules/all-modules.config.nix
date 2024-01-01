{ ... }:

{
  # Import all modules.
  imports = [
    # User Settings
    ./Users/kotz.config.nix # Kotz

    # Bootloaders
    ./Core/Boot/grub.kotz.config.nix # GRUB Bootloader

    # Audio
    ./Core/Audio/pipewire.kotz.config.nix # Pipewire

    # Graphics
    ./Core/Graphics/DEs/pantheon.kotz.config.nix # Pantheon Desktop Environment

    # Drivers
    ./Core/Drivers/spice.kotz.config.nix # Spice-Agent Drivers

    # Apps
    ./Apps/Virtualization/docker.kotz.config.nix # Docker
    ./Apps/Patching/nix-alien.kotz.config.nix # nix-alien

    # Misc
    ./Core/Misc/locale.kotz.config.nix # Localization settings
    ./Core/Misc/network.kotz.config.nix # Networking settings

    # Dependencies
    ./Dependencies/nur.config.nix # Nix User Repository
  ];
}
