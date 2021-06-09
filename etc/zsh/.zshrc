#!/usr/bin/env zsh

# Path to your oh-my-zsh installation.
export ZSH=/usr/local/share/zsh/oh-my-zsh
export ZSH_SHARE=/usr/local/share/workspace/share/zsh

# Load this zshrc
if [ -f $ZSH_SHARE/zshrc ]; then
  source $ZSH_SHARE/zshrc
fi
