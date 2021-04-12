FROM alpine:latest

ARG WS_USER=nonfiction
ARG WS_HOME=/home/nonfiction
ARG WS_CONFIG=/home/nonfiction/.config
ARG WS_DATA=/home/nonfiction/.local/share

# workspace user
RUN apk update && apk add sudo git
RUN adduser -h $WS_HOME -s /bin/zsh $WS_USER | echo password
WORKDIR $WS_HOME
ENV HOME $WS_HOME
RUN echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel
RUN addgroup $WS_USER wheel

# code-server
RUN apk update && apk add npm alpine-sdk libstdc++ libc6-compat python2 python3 bash
RUN npm config set python python3
RUN npm install -g --unsafe-perm code-server

# npm & webpack
RUN apk update && apk add npm
RUN npm install -g webpack webpack-cli webpack-dev-server eslint stylelint

# ruby & thor
RUN apk update && apk add make less curl unzip rsync dialog ruby
RUN gem install -f thor dotenv

# mysql client
RUN apk update && apk add mariadb-client mariadb-connector-c
RUN ln -sf $WS_CONFIG/mysql/.my.cnf $WS_HOME/.my.cnf

# sshd
RUN apk update && apk add openrc openssh openssh-client mosh
RUN ln -sf $WS_CONFIG/ssh $WS_HOME/.ssh
RUN mkdir -p /run/openrc && touch /run/openrc/softlevel && rc-update add sshd
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo "Port 2222" >> /etc/ssh/sshd_config

# php & composer
RUN apk update && apk add composer

# docker & docker-compose
RUN apk update && apk add docker docker-compose
RUN addgroup $WS_USER docker

# tools
RUN apk update && \
    apk add zsh tmux fzf nnn neovim neovim-doc neovim-lang fzf-neovim \
    highlight ack ripgrep the_silver_searcher

RUN set -ex; \
  cd /etc/zsh; \
  echo "export WS_USER=$WS_USER"                    >> zshenv; \
  echo "export WS_HOME=$WS_HOME"                    >> zshenv; \
  echo "export WS_CONFIG=$WS_CONFIG"                >> zshenv; \
  echo "export WS_DATA=$WS_DATA"                    >> zshenv; \
  echo "export XDG_CONFIG_HOME=~/.config"           >> zshenv; \
  echo "export XDG_CACHE_HOME=~/.cache"             >> zshenv; \
  echo "export XDG_DATA_HOME=~/.local/share"        >> zshenv; \ 
  echo "export ZDOTDIR=$HOME/.config/zsh"           >> zshenv; \
  echo "export HISTFILE=~/.local/share/zsh/history" >> zshenv;


# Ensure path exists, but also make sure these directories don't
RUN mkdir -p $WS_CONFIG $WS_DATA && rm -rf $WS_CONFIG $WS_DATA

# Copy the config and data directories
COPY ./config $WS_CONFIG
COPY ./data $WS_DATA

# # COPY ./dotfiles /home/nonfiction/.dotfiles
# # RUN ln -sf /home/nonfiction/.dotfiles/rcrc /home/nonfiction/.rcrc
# # RUN su nonfiction && cd && rcup -f
#
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git $WS_DATA/zsh/oh-my-zsh
# RUN git clone --depth 1 https://github.com/junegunn/fzf.git $WS_HOME/.fzf
#
# # tmux plugin manager
RUN git clone https://github.com/tmux-plugins/tpm $WS_DATA/tmux/plugins/tpm
#
# # vim-plug
RUN curl -fL https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > $WS_DATA/nvim/site/autoload/plug.vim 


RUN chown -R $WS_USER:$WS_USER $WS_HOME

COPY ./run.sh /bin/run
RUN chmod +x /bin/run
CMD ["/bin/run"]

EXPOSE 8443
EXPOSE 2222
