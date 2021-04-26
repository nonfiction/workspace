#!/usr/bin/env zsh

# Path to your oh-my-zsh installation.
export ZSH=/data/zsh/oh-my-zsh

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="muse"

# Use hyphen-insensitive completion.
HYPHEN_INSENSITIVE="true"

# Disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Stop changing the window title
DISABLE_AUTO_TITLE="true"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(fzf git gitignore sudo rsync)

source $ZSH/oh-my-zsh.sh

# Path
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export PATH="./bin:$HOME/bin:$PATH"

# Path on separate lines
path() {
  echo $PATH | tr ':' '\n'
}

# Use Neovim as "preferred editor"
export EDITOR=nvim
export VISUAL=nvim
alias vim=nvim
alias vi=nvim

# python
alias server="python -m SimpleHTTPServer"

# True if command or file does exist
has() {
  if [ -e "$1" ]; then return 0; fi
  command -v $1 >/dev/null 2>&1 && { return 0; }
  return 1
}

# True if command or file doesn't exist
hasnt() {
  if [ -e "$1" ]; then return 1; fi
  command -v $1 >/dev/null 2>&1 && { return 1; }
  return 0
}

# True if variable is not empty
defined() {
  if [ -z "$1" ]; then return 1; fi  
  return 0
}

# True if variable is empty
undefined() {
  if [ -z "$1" ]; then return 0; fi
  return 1
}

# Source gracefully
source() {
  if [ -f "$1" ]; then
    builtin source "$1" && return 0;
  fi
}

# update-everything() {
#   cd ~/.oh-my-zsh && git pull
#   cd ~/.fzf && git pull
#   nvim -E -c PackUpdate -c q
#   ~/.local/share/tmux/plugins/tpm/bin/install_plugins all
#   ~/.local/share/tmux/plugins/tpm/bin/update_plugins all
#   rcdn && ln -sf ~/.dotfiles/rcrc ~/.rcrc && rcup
# }

n ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

source $ZDOTDIR/.shellfishrc
