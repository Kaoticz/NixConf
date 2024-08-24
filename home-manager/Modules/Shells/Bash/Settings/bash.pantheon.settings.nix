{ pkgs }:

{
  # Define aliases
  aliases = {
    homenix = "io.elementary.code ~/.config/home-manager/home.nix & disown";
    wingpanel = "io.elementary.wingpanel > /dev/null 2>&1 & disown";
  };

  # Define the bashrc for Pantheon DE
  bashrc = ''
    # If the profile was not loaded in a parent process, source
    # it.  But otherwise don't do it because we don't want to
    # clobber overridden values of $PATH, etc.
    if [ -z "$__ETC_PROFILE_DONE" ]; then
        . /etc/profile
    fi

    # We are not always an interactive shell.
    if [ -n "$PS1" ]; then
        # Show current working directory in VTE terminals window title.
        # Supports both bash and zsh, requires interactive shell.
        . "${pkgs.vte}/etc/profile.d/vte.sh"

        # This function is called whenever a command is not found.
        command_not_found_handle() {
          local p='/nix/store/shch4787c8drgi8q6ahksrcjhsjyc2gy-command-not-found/bin/command-not-found'
          if [ -x "$p" ] && [ -f '/nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite' ]; then
            # Run the helper program.
            "$p" "$@"
            # Retry the command if we just installed it.
            if [ $? = 126 ]; then
              "$@"
            else
              return 127
            fi
          else
            echo "$1: command not found" >&2
            return 127
          fi
        }

        # Check the window size after every command.
        shopt -s checkwinsize

        # Disable hashing (i.e. caching) of command lookups.
        #set +h

        # Provide a nice prompt if the terminal supports it.
        if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
          PROMPT_COLOR="1;31m"
          ((UID)) && PROMPT_COLOR="1;32m"
          if [ -n "$INSIDE_EMACS" ] || [ "$TERM" = "eterm" ] || [ "$TERM" = "eterm-color" ]; then
            # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
            PS1="\n\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
          else
            PS1="\n\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "
          fi
          if test "$TERM" = "xterm"; then
            PS1="\[\033]2;\h:\u:\w\007\]$PS1"
          fi
        fi

        eval "$(${pkgs.coreutils}/bin/dircolors -b)"

        # Check whether we're running a version of Bash that has support for
        # programmable completion. If we do, enable all modules installed in
        # the system and user profile in obsolete /etc/bash_completion.d/
        # directories. Bash loads completions in all
        # $XDG_DATA_DIRS/bash-completion/completions/
        # on demand, so they do not need to be sourced here.
        if shopt -q progcomp &>/dev/null; then
          . "${pkgs.bash-completion}/etc/profile.d/bash_completion.sh"
          nullglobStatus=$(shopt -p nullglob)
          shopt -s nullglob
          for p in $NIX_PROFILES; do
            for m in "$p/etc/bash_completion.d/"*; do
              . "$m"
            done
          done
          eval "$nullglobStatus"
          unset nullglobStatus p m
        fi
    fi

    # Read system-wide modifications.
    if test -f /etc/bashrc; then
        . /etc/bashrc
    fi
  '';
}
