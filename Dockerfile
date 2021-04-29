FROM alpine:latest

# code-server
RUN apk update && apk add npm alpine-sdk libstdc++ libc6-compat python2 python3 bash
RUN npm config set python python3
RUN npm install -g --unsafe-perm code-server

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
    iputils \
    zsh tmux fzf nnn neovim neovim-doc neovim-lang fzf-neovim \
    highlight fd ack ripgrep the_silver_searcher

RUN set -ex; \
  cd /etc/zsh; \
  echo "export LANG=en_US.UTF-8" >> zshenv; \
  echo "export LANGUAGE=en_US:en" >> zshenv; \
  echo "export LC_ALL=en_US.UTF-8" >> zshenv; \
  echo "export XDG_CONFIG_HOME=/config" >> zshenv; \
  echo "export XDG_CACHE_HOME=/cache" >> zshenv; \
  echo "export XDG_DATA_HOME=/data" >> zshenv; \
  echo "export ZDOTDIR=/config/zsh" >> zshenv; \
  echo "export HISTFILE=/data/zsh/history" >> zshenv; \
  echo "export NPM_CONFIG_USERCONFIG=/config/npm/npmrc" >> zshenv; \
  echo "export DOCKER_CONFIG=/data/docker" >> zshenv; \
  echo "export MACHINE_STORAGE_PATH=/data/docker-machine" >> zshenv;

# Copy the config and set data volume
COPY --chown=work:work ./config /config
VOLUME /cache
VOLUME /data
VOLUME /work
WORKDIR /work

COPY ./run.sh /bin/run
RUN chmod +x /bin/run
CMD ["/bin/run"]

EXPOSE 8443
EXPOSE 2222
