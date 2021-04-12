#!/bin/zsh

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
cd /home/nonfiction
[ ! -z "$DB_USER" ] && sed -i "s/__USER__/${DB_USER}/" .my.cnf
[ ! -z "$DB_PASSWORD" ] && sed -i "s/__PASSWORD__/${DB_PASSWORD}/" .my.cnf
[ ! -z "$DB_HOST" ] && sed -i "s/__HOST__/${DB_HOST}/" .my.cnf
[ ! -z "$DB_PORT" ] && sed -i "s/__PORT__/${DB_PORT}/" .my.cnf

# Password for code-server
cd /home/nonfiction/.config/code-server/
[ ! -z "$CODE_PASSWORD" ] && sed -i "s/__PASSWORD__/${CODE_PASSWORD}/" config.yaml

# sshd on port 2222
service sshd start

# Run code-server
cd /home/nonfiction
/bin/su -c "/usr/bin/code-server" - nonfiction
