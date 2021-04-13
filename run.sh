#!/bin/zsh

CONFIG=/home/nf/.config
DATA=/home/nf/.local/share

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

# Update password for user
if [ ! -z "$SUDO_PASSWORD" ]; then
  echo "nonfiction:${SUDO_PASSWORD}" | chpasswd
fi

# Git config
if [ ! -z "$GIT_USER_NAME" ] && [ ! -z "$GIT_USER_EMAIL" ]; then
  git config --global user.name "$GIT_USER_NAME"
  git config --global user.email "$GIT_USER_EMAIL"
  git config credential.helper store
fi

# Settings for mysql client
cd $CONFIG/mysql
[ ! -z "$DB_USER" ] && sed -i "s/__USER__/${DB_USER}/" .my.cnf
[ ! -z "$DB_PASSWORD" ] && sed -i "s/__PASSWORD__/${DB_PASSWORD}/" .my.cnf
[ ! -z "$DB_HOST" ] && sed -i "s/__HOST__/${DB_HOST}/" .my.cnf
[ ! -z "$DB_PORT" ] && sed -i "s/__PORT__/${DB_PORT}/" .my.cnf

# Password for code-server
cd $CONFIG/code-server
[ ! -z "$CODE_PASSWORD" ] && sed -i "s/__PASSWORD__/${CODE_PASSWORD}/" config.yaml

# Default settings for code-server
mkdir -p $DATA/code-server/User
[ -e $DATA/code-server/User/settings.json ] || cp $CONFIG/code-server/settings.json $DATA/code-server/User/settings.json

# # sshd on port 2222
# service sshd start

chown -R nf: /home/nf
chown -R nf: /var/run/docker.sock

# Run code-server
su -c "cd /home/nf/workspace && code-server" - nf
