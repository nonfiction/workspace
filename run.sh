#!/bin/zsh

# https://wiki.archlinux.org/title/XDG_Base_Directory
CONFIG=/work/.config
DATA=/work/.local/share
CACHE=/work/.cache

# Shell helper functions
source $CONFIG/zsh/helpers.sh

# Update password for user
SUDO_PASSWORD=$(env_file_default SUDO_PASSWORD /run/secrets/sudo_password "secret")
if [ ! -z "$SUDO_PASSWORD" ]; then
  echo "work:${SUDO_PASSWORD}" | chpasswd
fi

# symlink config to the home directory
[ -e /work/.config ] || ln -s /config /work/.config

# oh-my-zsh
mkdir -p $DATA/zsh
[ -e $DATA/zsh/oh-my-zsh ] || git clone https://github.com/robbyrussell/oh-my-zsh.git $DATA/zsh/oh-my-zsh

# fzf
[ -e $DATA/fzf ] || git clone --depth 1 https://github.com/junegunn/fzf.git $DATA/fzf

# tmux plugin manager
mkdir -p $DATA/tmux/plugins
[ -e $DATA/tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm $DATA/tmux/plugins/tpm
[ -e $DATA/tmux/plugins/tpm/bin/install_plugins ] && $DATA/tmux/plugins/tpm/bin/install_plugins

# vim-plug
mkdir -p $DATA/nvim/site/{autoload,plugged}
curl -fL https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > $DATA/nvim/site/autoload/plug.vim
[ -e $DATA/nvim/site/autoload/custom.vim ] || cp $CONFIG/nvim/custom.vim $DATA/nvim/site/autoload/custom.vim
nvim +PlugInstall +qall >> /dev/null

# PHP Composer
mkdir -p $DATA/composer 
[ -e /work/.composer ] || ln -s $DATA/composer /work/.composer

# npm
mkdir -p $DATA/npm $CACHE/npm

# Git & Github
cd $CONFIG/git

GIT_NAME=$(env_file_default GIT_NAME /run/secrets/git_name "nonfiction")
[ ! -z "$GIT_NAME" ] && sed -i "s/__NAME__/${GIT_NAME}/" config

GIT_EMAIL=$(env_file_default GIT_EMAIL /run/secrets/git_email "web@nonfiction.ca")
[ ! -z "$GIT_EMAIL" ] && sed -i "s/__EMAIL__/${GIT_EMAIL}/" config

GITHUB_USER=$(env_file_default GITHUB_USER /run/secrets/github_user "nonfiction-studios")
[ ! -z "$GITHUB_USER" ] && sed -i "s/__USER__/${GITHUB_USER}/" credentials

GITHUB_TOKEN=$(env_file_default GITHUB_TOKEN /run/secrets/github_token)
[ ! -z "$GITHUB_TOKEN" ] && sed -i "s/__TOKEN__/${GITHUB_TOKEN}/" credentials


# Settings for mysql client
cd $CONFIG/mysql
ln -sf $CONFIG/mysql/.my.cnf /work/.my.cnf

DB_USER=$(env_file_default DB_USER /run/secrets/db_user "root")
[ ! -z "$DB_USER" ] && sed -i "s/__USER__/${DB_USER}/" .my.cnf

DB_PASSWORD=$(env_file_default DB_PASSWORD /run/secrets/db_password "secret")
[ ! -z "$DB_PASSWORD" ] && sed -i "s/__PASSWORD__/${DB_PASSWORD}/" .my.cnf

DB_HOST=$(env_file_default DB_HOST /run/secrets/db_host "127.0.0.1")
[ ! -z "$DB_HOST" ] && sed -i "s/__HOST__/${DB_HOST}/" .my.cnf

DB_PORT=$(env_file_default DB_PORT /run/secrets/db_port "3306")
[ ! -z "$DB_PORT" ] && sed -i "s/__PORT__/${DB_PORT}/" .my.cnf


# Password for code-server
cd $CONFIG/code-server
CODE_PASSWORD=$(env_file_default CODE_PASSWORD /run/secrets/code_server "secret")
[ ! -z "$CODE_PASSWORD" ] && sed -i "s/__PASSWORD__/${CODE_PASSWORD}/" config.yaml

# Default settings for code-server
mkdir -p $DATA/code-server/User
[ -e $DATA/code-server/User/settings.json ] || cp $CONFIG/code-server/settings.json $DATA/code-server/User/settings.json

# ssh on port 2222
[ -e /work/.ssh ] || ln -s $CONFIG/ssh /work/.ssh
rc-status
/etc/init.d/sshd start

# Permissions on home directories and docker.sock
chown -R work:work /config /work
chown -R work: /var/run/docker.sock

# Run code-server
su -c "cd /work && code-server" - work
