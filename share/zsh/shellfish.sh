# include this from .bashrc, .zshrc or
# another shell startup file with:
#   source $HOME/.shellfishrc

# this script does nothing outside ShellFish
if [[ "$LC_TERMINAL" = "ShellFish" ]]; then
  ios_printURIComponent() {
    awk 'BEGIN {while (y++ < 125) z[sprintf("%c", y)] = y
    while (y = substr(ARGV[1], ++j, 1))
    q = y ~ /[a-zA-Z0-9]/ ? q y : q sprintf("%%%02X", z[y])
    printf("%s", q)}' "$1"
  }
  
  which printf > /dev/null
  ios_hasPrintf=$?
  ios_printf() {
    if [ $ios_hasPrintf ]; then
      printf "$1"
    else
      awk "BEGIN {printf \"$1\"}"
    fi
  }

  ios_printOSC() {
    if [[ -n "$TMUX" ]]; then
      ios_printf '\033Ptmux;\033\033]'
    else
      ios_printf '\033]'
    fi
  }

  ios_printST() {
    if [[ -n "$TMUX" ]]; then
      ios_printf '\a\033\\'
    else
      ios_printf '\a'
    fi
  }
  
  # prepare fifo for communicating result back to shell
  ios_prepareResult() {
    FIFO=$(mktemp)
    rm -f $FIFO
    mkfifo $FIFO
    echo $FIFO
  }
    
  # wait for terminal to complete action
  ios_handleResult() {
    FIFO=$1
    if [ -n "$FIFO" ]; then
      read <$FIFO -s
      rm -f $FIFO
    
      if [[ $REPLY = error* ]]; then
        echo "${REPLY#error=}" | base64 >&2 -d
        return 1
      fi
  
      if [[ $REPLY = result* ]]; then
        echo "${REPLY#result=}" | base64 -d
      fi
    fi
  }

  sharesheet() {
      if [[ $# -eq 0 ]]; then
        if tty -s; then
          cat <<EOF
Usage: sharesheet [FILE]...

Present share sheet for files and directories. Alternatively you can pipe in text and call it without arguments.

If arguments exist inside the Files app changes made are written back to the server.
EOF
        return 0
      fi
    fi

    FIFO=$(ios_prepareResult)
    ios_printOSC
    awk 'BEGIN {printf "6;sharesheet://?respond="}'
    ios_printURIComponent "$FIFO"
    awk 'BEGIN {printf "&pwd="}'
    ios_printURIComponent "$PWD"
    awk 'BEGIN {printf "&home="}'
    ios_printURIComponent "$HOME"
    for var in "$@"
    do
      awk 'BEGIN {printf "&path="}'
      ios_printURIComponent "$var"
    done
    if [[ $# -eq 0 ]]; then
      text=$(cat -)
      awk 'BEGIN {printf "&text="}'
      ios_printURIComponent "$text"
    fi
    ios_printST
    ios_handleResult "$FIFO"
  }
  
  quicklook() {
    if [[ $# -eq 0 ]]; then
      if tty -s; then
            cat <<EOF
Usage: quicklook [FILE]...

Show QuickLook preview for files and directories. Alternatively you can pipe in text and call it without arguments.
EOF
        return 0
      fi
    fi
  
    FIFO=$(ios_prepareResult)
    ios_printOSC
    awk 'BEGIN {printf "6;quicklook://?respond="}'
    ios_printURIComponent "$FIFO"
    awk 'BEGIN {printf "&pwd="}'
    ios_printURIComponent "$PWD"
    awk 'BEGIN {printf "&home="}'
    ios_printURIComponent "$HOME"
    for var in "$@"
    do
      awk 'BEGIN {printf "&path="}'
      ios_printURIComponent "$var"
    done
    if [[ $# -eq 0 ]]; then
      text=$(cat -)
      awk 'BEGIN {printf "&text="}'
      ios_printURIComponent "$text"
    fi
    ios_printST
    ios_handleResult "$FIFO"
  }

  textastic() {
    if [[ $# -eq 0 ]]; then
      cat <<EOF
Usage: textastic <text-file>

Open in Textastic 9.5 or later.
File must be in directory represented in the Files app to allow writing back edits.
EOF
    else
      ios_printOSC
      awk 'BEGIN {printf "6;textastic://?pwd="}'
      ios_printURIComponent "$PWD"
      awk 'BEGIN {printf "&home="}'
      ios_printURIComponent "$HOME"
      awk 'BEGIN {printf "&path="}'
      ios_printURIComponent "$1"
      ios_printST
    fi
  }
  
  openUrl() {
    if [[ $# -eq 0 ]]; then
      cat <<EOF
Usage: openUrl <url>

Open URL on iOS.
EOF
    else
      FIFO=$(ios_prepareResult)
      ios_printOSC
      awk 'BEGIN {printf "6;open://?respond="}'
      ios_printURIComponent "$FIFO"
      awk 'BEGIN {printf "&url="}'
      ios_printURIComponent "$1"
      ios_printST
      ios_handleResult "$FIFO"
    fi
  }

  runShortcut() {
    local baseUrl="shortcuts://run-shortcut"
    if [[ $1 == "--x-callback" ]]; then
        local baseUrl="shortcuts://x-callback-url/run-shortcut"
        shift
    fi

    if [[ $# -eq 0 ]]; then
      cat <<EOF
Usage: runShortcut [--x-callback] <shortcut-name> [input-for-shortcut]

Run in Shortcuts app bringing back results if --x-callback is included.
EOF
    else
      local name=$(ios_printURIComponent "$1")
      shift
      local input=$(ios_printURIComponent "$*")
      openUrl "$baseUrl?name=$name&input=$input"
    fi
  }

  notify() {
    if [[ $# -eq 0 ]]; then
      cat <<EOF
Usage: notify <title> [body]

Show notification on iOS device.
Title cannot contain semicolon.
EOF
    else
      local title="${1-}" body="${2-}"
      ios_printOSC
      echo $title | awk -F";" 'BEGIN {printf "777;notify;"} {printf "%s;", $1}'
      echo $body
      ios_printST
    fi
  }

  # copy standard input or arguments to iOS clipboard
  pbcopy() {
    ios_printOSC
    awk 'BEGIN {printf "52;c;"} '
    if [ $# -eq 0 ]; then
      base64 | tr -d '\n'
    else
      echo -n "$@" | base64 | tr -d '\n'
    fi
    ios_printST
  }

  # Secure ShellFish supports 24-bit colors
  export COLORTERM=truecolor
  
  if [[ -z "$INSIDE_EMACS" && $- = *i* ]]; then
    # tmux mouse mode enables scrolling with
    # two-finger swipe and mouse wheel
    if [[ -n "$TMUX" ]]; then
      tmux set -g mouse on
    fi

    # send the current directory using OSC 7 when showing prompt to
    # make filename detection work better for interactive shell
    update_terminal_cwd() {
      ios_printOSC
      awk "BEGIN {printf \"7;%s\", \"file://$HOSTNAME\"}"
      ios_printURIComponent "$PWD"
      ios_printST
    }
    if [ -n "$ZSH_VERSION" ]; then
      precmd() { update_terminal_cwd; }
    elif [[ $PROMPT_COMMAND != *"update_terminal_cwd"* ]]; then
      PROMPT_COMMAND="update_terminal_cwd${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
    fi
  fi
fi
