''
  ## Prints learning material about a programming language or a tool to stdout.
  ## Usage: cheat <language>
  cheat()
  {
      [[ -n $1 ]] && curl cheat.sh/"$1"/:learn || curl cheat.sh
  }

  ## Extracts a compressed file.
  ## Usage: extract <file>
  extract()
  {
      if [ -f "$1" ] ; then
        case $1 in
          *.tar.bz2)   tar xjf "$1"   ;;
          *.tar.gz)    tar xzf "$1"   ;;
          *.bz2)       bunzip2 "$1"   ;;
          *.rar)       unrar x "$1"   ;;
          *.gz)        gunzip "$1"    ;;
          *.tar)       tar xf "$1"    ;;
          *.tbz2)      tar xjf "$1"   ;;
          *.tgz)       tar xzf "$1"   ;;
          *.zip)       unzip "$1"     ;;
          *.Z)         uncompress "$1";;
          *.7z)        7z x "$1"      ;;
          *.deb)       ar x "$1"      ;;
          *.tar.xz)    tar xf "$1"    ;;
          *.tar.zst)   unzstd "$1"    ;;
          *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
      else
        echo "'$1' is not a valid file"
      fi
  }

  ## Swaps the name of one file with another (also works for directories, drives and pipes).
  ## Usage: swap <test1.txt> <test2.txt>
  swap()
  {
      test $# -eq 2 || return 2

      test -e "$1" || return 3
      test -e "$2" || return 3

      local -r lname="$(basename "$1")"
      local -r rname="$(basename "$2")"
      local -r owner1="$(stat -c '%U' $1)"
      local -r owner2="$(stat -c '%U' $2)"
      local -r priv=$([[ $owner1 == "root" || $owner2 == "root" ]] && echo "sudo" || echo "")

      ( cd "$(dirname "$1")" && $priv mv -T "$lname" ".$rname" ) && \
      ( cd "$(dirname "$2")" && $priv mv -T "$rname" "$lname" ) && \
      ( cd "$(dirname "$1")" && $priv mv -T ".$rname" "$rname" )
  }

  ## Replace ls with exa.
  ## Usage: ls <args> <file_path>
  ## Example args: -l, -a, -Ta, -lah
  _ls()
  {
      local -r exa_args='--color=always --group-directories-first --icons'

      if [[ $* =~ -.+$ ]]; then
          exa $exa_args "$@"
      else
          exa $exa_args -la "$@"
      fi
  }

  alias ls='_ls'
''
