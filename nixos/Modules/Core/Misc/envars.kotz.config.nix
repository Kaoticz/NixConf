{ lib, config, ... }:
let
  cfg = config.kotz.envars;
in
{
  # Imports: extra modules this module uses.
  imports = [ ];

  # Options: settings the user can change.
  options.kotz.envars = {
    enable = lib.mkEnableOption "Kotz's global environment variables.";
  };

  # Config: things that must be done if this module is enabled.
  config = lib.mkIf cfg.enable {
    # Environment variables set by PAM.
    environment.sessionVariables = {
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };

    # Global environment variables set in "/etc/profile.d".
    environment.variables = {
      # XDG Apps
      GNUPGHOME = "$XDG_DATA_HOME/gnupg";
      HISTFILE = "$XDG_STATE_HOME/bash/history";
      LESSHISTFILE = "$XDG_CACHE_HOME/less/history";
      CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
      GTK2_RC_FILES = "$XDG_CONFIG_HOME/gtk-2.0/gtkrc";
      KDEHOME = "$XDG_CONFIG_HOME/kde";
      NUGET_PACKAGES = "$XDG_CACHE_HOME/NuGetPackages";
      PYTHONSTARTUP = "$XDG_CONFIG_HOME/python/pythonrc";
      SQLITE_HISTORY = "$XDG_CACHE_HOME/sqlite_history";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"; # Some applications do not respect this.

      # Terminal things
      GPG_TTY = "$(tty)"; # Enable commit signing in the shell
      EDITOR = "nano"; # Set nano as the default text editor for sudoedit

      # Docker
      DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
      DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/docker.sock";
    };
  };
}
