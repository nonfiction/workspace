FROM alpine:latest

# basics
RUN apk update && apk add openrc openssh openssh-client mosh sudo git

# nonfiction user
RUN adduser -h /home/nonfiction -s /bin/zsh nonfiction | echo password
WORKDIR /home/nonfiction
ENV HOME /home/nonfiction
RUN echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel
RUN addgroup nonfiction wheel

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

# php & composer
RUN apk update && apk add composer

# docker & docker-compose
RUN apk update && apk add docker docker-compose
RUN addgroup nonfiction docker

# tools
RUN apk update && \
    apk add bash zsh rcm tmux fzf nnn neovim neovim-doc neovim-lang fzf-neovim \
    highlight ack ripgrep the_silver_searcher

COPY ./dotfiles /home/nonfiction/.dotfiles
RUN ln -sf /home/nonfiction/.dotfiles/rcrc /home/nonfiction/.rcrc
RUN su nonfiction && cd && rcup -f

RUN git clone https://github.com/robbyrussell/oh-my-zsh.git /home/nonfiction/.oh-my-zsh
RUN git clone --depth 1 https://github.com/junegunn/fzf.git /home/nonfiction/.fzf

# tmux plugin manager
RUN git clone https://github.com/tmux-plugins/tpm /home/nonfiction/.local/share/tmux/plugins/tpm

# vim-plug
RUN curl -fL https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > /home/nonfiction/.local/share/nvim/site/autoload/plug.vim 


RUN chown -R nonfiction:nonfiction /home/nonfiction

COPY ./run.sh /bin/run
RUN chmod +x /bin/run
CMD ["/bin/run"]

EXPOSE 8443
