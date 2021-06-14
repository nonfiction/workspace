FROM alpine:latest

# code-server
RUN apk update && apk add npm alpine-sdk libstdc++ libc6-compat python2 python3 bash
RUN npm config set python python3
RUN npm install -g --unsafe-perm code-server@3.9.3

# workspace user
RUN apk update && apk add sudo git
RUN adduser -h /work -s /bin/zsh work | echo password
ENV HOME /work
RUN echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel
RUN addgroup work wheel

# npm & webpack
RUN apk update && apk add npm
RUN npm install -g webpack webpack-cli webpack-dev-server eslint stylelint

# ruby & thor
USER root
RUN apk update && apk add make less curl unzip rsync dialog ruby
RUN gem install -f thor dotenv

# mysql client
RUN apk update && apk add mariadb-client mariadb-connector-c

# sshd
RUN apk update && apk add openrc openssh openssh-client mosh
RUN mkdir -p /etc/ssh
RUN mkdir -p /run/openrc && touch /run/openrc/softlevel && rc-update add sshd
RUN echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
RUN echo "Port 2222" >> /etc/ssh/sshd_config
RUN ssh-keygen -A

# php & composer
RUN apk update && apk add \
    composer php7-common php7-ctype php7-tokenizer php7-gd \
    php7-mysqli php7-exif php7-opcache php7-zip php7-xml \
    php7-curl php7-mbstring php7-xmlwriter php7-simplexml

# docker & docker-compose
RUN apk update && apk add docker docker-compose
RUN addgroup work docker

# tools
RUN apk update && apk add \
    esh iputils ncurses asciidoctor \
    zsh tmux fzf nnn neovim neovim-doc neovim-lang fzf-neovim \
    highlight fd ack ripgrep the_silver_searcher

RUN set -ex; \
  cd /etc/zsh; \
  echo "export LANG=en_US.UTF-8" >> zshenv; \
  echo "export LANGUAGE=en_US:en" >> zshenv; \
  echo "export LC_ALL=en_US.UTF-8" >> zshenv; \
  echo "export XDG_CONFIG_HOME=/usr/local/etc" >> zshenv; \
  echo "export XDG_CACHE_HOME=/usr/local/cache" >> zshenv; \
  echo "export XDG_DATA_HOME=/usr/local/share" >> zshenv; \
  echo "export ZDOTDIR=/usr/local/etc/zsh" >> zshenv; \
  echo "export HISTFILE=/usr/local/share/zsh/history" >> zshenv; \
  echo "export NPM_CONFIG_USERCONFIG=/usr/local/etc/npm/npmrc" >> zshenv; \
  echo "export DOCKER_CONFIG=/usr/local/share/docker" >> zshenv; \
  echo "export MACHINE_STORAGE_PATH=/usr/local/share/docker-machine" >> zshenv;

# Copy the config and set data volume
COPY --chown=work:work ./etc /usr/local/etc
VOLUME /usr/local/env
VOLUME /usr/local/share
VOLUME /usr/local/cache
VOLUME /work
WORKDIR /work

COPY --chown=work:work ./bin /usr/local/bin
CMD ["/usr/local/bin/workspace-init"]

EXPOSE 8443
EXPOSE 2222
