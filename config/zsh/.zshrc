#!/usr/bin/env zsh

# Path to your oh-my-zsh installation.
export ZSH=/config/data/zsh/oh-my-zsh

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

# Insecure completion-dependent directories detected
ZSH_DISABLE_COMPFIX="true"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git gitignore sudo rsync)

# Load Oh my ZSH!
source $ZSH/oh-my-zsh.sh

# Shell Helpers 
source /config/zsh/shelper.sh

# Path
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export PATH="./bin:$HOME/bin:$PATH"

# Editor
export EDITOR=nvim
export VISUAL=nvim
alias vim=nvim
alias vi=nvim

# Customize FZF
source /config/zsh/fzf.sh

# Ctrl-n nnn
source /config/zsh/nnn.sh

# Secure Shellfish integration
source /config/zsh/shellfish.sh

# Misc
alias server="python -m SimpleHTTPServer"
