#!/bin/zsh

# Update password for user
if [ ! -z "$SUDO_PASSWORD" ]; then
  echo "work:${SUDO_PASSWORD}" | chpasswd
fi

# Just in case
[ -e /work/.config ] || ln -s /config /work/.config

# oh-my-zsh
mkdir -p /config/data/zsh
[ -e /config/data/zsh/oh-my-zsh ] || git clone https://github.com/robbyrussell/oh-my-zsh.git /config/data/zsh/oh-my-zsh

# fzf
[ -e /config/data/fzf ] || git clone --depth 1 https://github.com/junegunn/fzf.git /config/data/fzf

# tmux plugin manager
mkdir -p /config/data/tmux/plugins
[ -e /config/data/tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm /config/data/tmux/plugins/tpm
[ -e /config/data/tmux/plugins/tpm/bin/install_plugins ] && /config/data/tmux/plugins/tpm/bin/install_plugins

# vim-plug
mkdir -p /config/data/nvim/site/{autoload,plugged}
curl -fL https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > /config/data/nvim/site/autoload/plug.vim
[ -e /config/data/nvim/site/autoload/custom.vim ] || cp /config/data/nvim/custom.vim /config/data/nvim/site/autoload/custom.vim
nvim +PlugInstall +qall >> /dev/null

# PHP Composer
mkdir -p /config/data/composer 
[ -e /work/.composer ] || ln -s /config/data/composer /work/.composer

# npm
mkdir -p /config/data/npm /config/cache/npm

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
mkdir -p /config/data/code-server/User
[ -e /config/data/code-server/User/settings.json ] || cp /config/code-server/settings.json /config/data/code-server/User/settings.json

# ssh on port 2222
[ -e /work/.ssh ] || ln -s /config/ssh /work/.ssh
rc-status
/etc/init.d/sshd start

# Permissions on home directories and docker.sock
chown -R work:work /config /work /config/data /config/cache
chown -R work: /var/run/docker.sock

# Run code-server
su -c "cd /work && code-server" - work
