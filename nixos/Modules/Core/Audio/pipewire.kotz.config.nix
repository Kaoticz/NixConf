{ lib, config, ... }:
let
  cfg = config.kotz.audio.pipewire;
in
{
  # Imports: extra modules this module uses.
  imports = [ ];

  # Options: settings the user can change.
  options.kotz.audio.pipewire = {
    enable = lib.mkEnableOption "Kotz's Pipewire configuration.";
  };

  # Config: things that must be done if this module is enabled.
  config = lib.mkIf cfg.enable {
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = false; # Set to 'true' if you want to use JACK applications.
    };
  };
}
