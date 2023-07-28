{
  aliases = {
    ls = "ls --color=auto";
    grep = "grep --color=auto";
  };

  bashrc = ''
    PS1='[\u@\h \W]\$ '
  '';
}
