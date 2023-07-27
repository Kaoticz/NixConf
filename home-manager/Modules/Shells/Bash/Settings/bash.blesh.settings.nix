{ pkgs, bashrc, ... }:
''
  # Blesh initialization
  [[ $- == *i* ]] && source "${pkgs.blesh}/share/blesh/ble.sh" --noattach

  ### .bashrc's Content - Start ###

  ${bashrc}

  ### .bashrc's Content - End ###

  # Add this line at the end of .bashrc:
  [[ $- == *i* ]] && ble-attach
''
