FROM alpine:latest

# code-server
RUN apk update && apk add npm alpine-sdk libstdc++ libc6-compat python2 python3 bash
RUN npm config set python python3
RUN npm install -g --unsafe-perm code-server

# workspace user
RUN apk update && apk add sudo git
RUN adduser -h /home/nonfiction -s /bin/zsh nonfiction | echo password
ENV HOME /home/nonfiction
RUN echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel
RUN addgroup nonfiction wheel

# npm & webpack
RUN apk update && apk add npm
RUN npm install -g webpack webpack-cli webpack-dev-server eslint stylelint

# ruby & thor
RUN apk update && apk add make less curl unzip rsync dialog ruby
RUN gem install -f thor dotenv

# mysql client
RUN apk update && apk add mariadb-client mariadb-connector-c
RUN ln -sf /home/nonfiction/.config/mysql/.my.cnf /home/nonfiction/.my.cnf

# sshd
RUN apk update && apk add openrc openssh openssh-client mosh
RUN ln -sf /home/nonfiction/.config/ssh /home/nonfiction/.ssh
RUN mkdir -p /run/openrc && touch /run/openrc/softlevel && rc-update add sshd
RUN echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
RUN echo "Port 2222" >> /etc/ssh/sshd_config
RUN ssh-keygen -A

# php & composer
RUN apk update && apk add composer

# docker & docker-compose
RUN apk update && apk add docker docker-compose
RUN addgroup nonfiction docker

# tools
RUN apk update && \
    apk add zsh tmux fzf nnn neovim neovim-doc neovim-lang fzf-neovim \
    highlight ack ripgrep the_silver_searcher

RUN set -ex; \
  cd /etc/zsh; \
  echo "export ZDOTDIR=/home/nonfiction/.config/zsh" >> zshenv; \
  echo "export HISTFILE=~/.local/share/zsh/history"  >> zshenv;

# Copy the config and data directories
COPY --chown=nonfiction:nonfiction ./config /home/nonfiction/.config
VOLUME /home/nonfiction/.local/share

# Work goes here
VOLUME /home/nonfiction/work
WORKDIR /home/nonfiction/work

COPY ./run.sh /bin/run
RUN chmod +x /bin/run
CMD ["/bin/run"]

EXPOSE 8443
EXPOSE 2222
