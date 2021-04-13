FROM alpine:latest

# code-server
RUN apk update && apk add npm alpine-sdk libstdc++ libc6-compat python2 python3 bash
RUN npm config set python python3
RUN npm install -g --unsafe-perm code-server

# workspace user
RUN apk update && apk add sudo git
RUN adduser -h /home/nf -s /bin/zsh nf | echo password
ENV HOME /home/nf
RUN echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel
RUN addgroup nf wheel

# npm & webpack
RUN apk update && apk add npm
RUN npm install -g webpack webpack-cli webpack-dev-server eslint stylelint

# ruby & thor
RUN apk update && apk add make less curl unzip rsync dialog ruby
RUN gem install -f thor dotenv

# mysql client
RUN apk update && apk add mariadb-client mariadb-connector-c
RUN ln -sf /home/nf/.config/mysql/.my.cnf /home/nf/.my.cnf

# sshd
RUN apk update && apk add openrc openssh openssh-client mosh
RUN ln -sf /home/nf/.config/ssh /home/nf/.ssh
RUN mkdir -p /run/openrc && touch /run/openrc/softlevel && rc-update add sshd
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo "Port 2222" >> /etc/ssh/sshd_config

# php & composer
RUN apk update && apk add composer

# docker & docker-compose
RUN apk update && apk add docker docker-compose
RUN addgroup nf docker

# tools
RUN apk update && \
    apk add zsh tmux fzf nnn neovim neovim-doc neovim-lang fzf-neovim \
    highlight ack ripgrep the_silver_searcher

RUN set -ex; \
  cd /etc/zsh; \
  echo "export XDG_CONFIG_HOME=~/.config"           >> zshenv; \
  echo "export XDG_CACHE_HOME=~/.cache"             >> zshenv; \
  echo "export XDG_DATA_HOME=~/.local/share"        >> zshenv; \ 
  echo "export ZDOTDIR=$HOME/.config/zsh"           >> zshenv; \
  echo "export HISTFILE=~/.local/share/zsh/history" >> zshenv;

# Ensure path exists, but also make sure these directories don't
#RUN mkdir -p /home/nf/.config /home/nf/.local/share && rm -rf /home/nf/.config /home/nf/.local/share

# Copy the config and data directories
COPY --chown=nf:nf ./config /home/nf/.config
VOLUME /home/nf/.local/share

VOLUME /home/nf/workspace
WORKDIR /home/nf/workspace


# # # Run as the workspace user
# # USER nf
#
# RUN git clone https://github.com/robbyrussell/oh-my-zsh.git /home/nf/.share/local/zsh/oh-my-zsh
# # RUN git clone --depth 1 https://github.com/junegunn/fzf.git $WS_HOME/.fzf
#
# # # tmux plugin manager
# RUN git clone https://github.com/tmux-plugins/tpm /home/nf/.share/local/tmux/plugins/tpm
# # RUN $WS_DATA/tmux/plugins/tpm/bin/install_plugins
#
# # # vim-plug
# RUN curl -fL https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > $WS_DATA/nvim/site/autoload/plug.vim
# # RUN nvim +PlugInstall +qall >> /dev/null
#
# #RUN chown -R $WS_USER:$WS_USER $WS_HOME
# USER root
#
# RUN mkdir -p /workspace && chown -R nf:nf /workspace
# WORKDIR /workspace
# # Setting permisions on home directory on docker.sock
# RUN chown -R nf: /home/nf

COPY ./run.sh /bin/run
RUN chmod +x /bin/run
CMD ["/bin/run"]

EXPOSE 8443
EXPOSE 2222
