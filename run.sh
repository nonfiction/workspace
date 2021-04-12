#!/bin/bash

# Update password for user
if [ ! -z "$SUDO_PASSWORD" ]; then
  echo "nonfiction:${SUDO_PASSWORD}" | chpasswd
fi

# Git config
if [ ! -z "$GIT_USER_NAME" ] && [ ! -z "$GIT_USER_EMAIL" ]; then
  git config --global user.name "$GIT_USER_NAME"
  git config --global user.email "$GIT_USER_EMAIL"
fi

# Settings for mysql client
cd /home/nonfiction
[ ! -z "$DB_USER" ] && sed -i "s/nfuser/${DB_USER}/" .my.cnf
[ ! -z "$DB_PASSWORD" ] && sed -i "s/nfpassword/${DB_PASSWORD}/" .my.cnf
[ ! -z "$DB_HOST" ] && sed -i "s/nfhost/${DB_HOST}/" .my.cnf
[ ! -z "$DB_PORT" ] && sed -i "s/nfport/${DB_PORT}/" .my.cnf

# Password for code-server
cd /home/nonfiction/.config/code-server/
[ ! -z "$CODE_PASSWORD" ] && sed -i "s/nfpassword/${CODE_PASSWORD}/" config.yaml

# Run code-server
cd /home/nonfiction
/bin/su -c "/usr/bin/code-server" - nonfiction
