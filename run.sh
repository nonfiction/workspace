#!/bin/zsh

# Update password for user
if [ ! -z "$SUDO_PASSWORD" ]; then
  echo "work:${SUDO_PASSWORD}" | chpasswd
fi

# Just in case
[ -e /work/.config ] || ln -s /config /work/.config

# oh-my-zsh
mkdir -p /data/zsh
[ -e /data/zsh/oh-my-zsh ] || git clone https://github.com/robbyrussell/oh-my-zsh.git /data/zsh/oh-my-zsh

# fzf
[ -e /data/fzf ] || git clone --depth 1 https://github.com/junegunn/fzf.git /data/fzf

# tmux plugin manager
mkdir -p /data/tmux/plugins
[ -e /data/tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm /data/tmux/plugins/tpm
[ -e /data/tmux/plugins/tpm/bin/install_plugins ] && /data/tmux/plugins/tpm/bin/install_plugins

# vim-plug
mkdir -p /data/nvim/site/{autoload,plugged}
curl -fL https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > /data/nvim/site/autoload/plug.vim
[ -e /data/nvim/site/autoload/custom.vim ] || cp /data/nvim/custom.vim /data/nvim/site/autoload/custom.vim
nvim +PlugInstall +qall >> /dev/null

# PHP Composer
mkdir -p /data/composer 
[ -e /work/.composer ] || ln -s /data/composer /work/.composer

# npm
mkdir -p /data/npm /cache/npm

# Git & Github
cd /config/git
[ ! -z "$GIT_NAME" ] && sed -i "s/__NAME__/${GIT_NAME}/" config
[ ! -z "$GIT_EMAIL" ] && sed -i "s/__EMAIL__/${GIT_EMAIL}/" config
[ ! -z "$GITHUB_USER" ] && sed -i "s/__USER__/${GITHUB_USER}/" credentials
[ ! -z "$GITHUB_TOKEN" ] && sed -i "s/__TOKEN__/${GITHUB_TOKEN}/" credentials

# Settings for mysql client
cd /config/mysql
[ ! -z "$DB_USER" ] && sed -i "s/__USER__/${DB_USER}/" .my.cnf
[ ! -z "$DB_PASSWORD" ] && sed -i "s/__PASSWORD__/${DB_PASSWORD}/" .my.cnf
[ ! -z "$DB_HOST" ] && sed -i "s/__HOST__/${DB_HOST}/" .my.cnf
[ ! -z "$DB_PORT" ] && sed -i "s/__PORT__/${DB_PORT}/" .my.cnf
ln -sf /config/mysql/.my.cnf /work/.my.cnf

# Password for code-server
cd /config/code-server
[ ! -z "$CODE_PASSWORD" ] && sed -i "s/__PASSWORD__/${CODE_PASSWORD}/" config.yaml

# Default settings for code-server
mkdir -p /data/code-server/User
[ -e /data/code-server/User/settings.json ] || cp /config/code-server/settings.json /data/code-server/User/settings.json

# ssh on port 2222
[ -e /work/.ssh ] || ln -s /config/ssh /work/.ssh
rc-status
/etc/init.d/sshd start

# Permissions on home directories and docker.sock
chown -R work:work /config /work /data /cache
chown -R work: /var/run/docker.sock

# Run code-server
su -c "cd /work && code-server" - work
