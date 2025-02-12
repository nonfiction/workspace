FROM alpine:3.16

# install these
RUN apk update && apk add npm alpine-sdk libstdc++ libc6-compat python3 bash

# workspace user
RUN apk update && apk add sudo git
RUN adduser -h /work -s /bin/zsh work | echo password
ENV HOME=/work
RUN echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel
RUN touch /var/lib/sudo/lectured/work
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
RUN sed -i 's/^AllowTcpForwarding no/AllowTcpForwarding yes/' /etc/ssh/sshd_config
RUN ssh-keygen -A

# php & composer
RUN apk update && apk add \
    composer php8-common php8-ctype php8-tokenizer php8-gd \
    php8-mysqli php8-exif php8-opcache php8-zip php8-xml php8-dom \
    php8-curl php8-mbstring php8-xmlwriter php8-simplexml

# docker
RUN apk update && apk add docker docker-cli docker-cli-buildx
RUN addgroup work docker 

# tools
RUN apk update && apk add \
    esh iputils ncurses asciidoctor apache2-utils htop \
    zsh tmux fzf fish nnn neovim neovim-doc neovim-lang fzf-neovim \
    highlight fd ack ripgrep the_silver_searcher \
    github-cli jq shadow

# Copy system config tweaks
COPY ./etc/ssh_config /etc/ssh/ssh_config
COPY ./etc/zshenv /etc/zsh/zshenv

# Copy the config and set data volume
COPY --chown=work:work ./config /usr/local/config
VOLUME /usr/local/env
VOLUME /usr/local/share
VOLUME /usr/local/cache
VOLUME /root
VOLUME /data
VOLUME /work
WORKDIR /work

COPY --chown=work:work ./bin /usr/local/bin
CMD ["/usr/local/bin/workspace-init"]

EXPOSE 8443
EXPOSE 2222
