include .env 

# up:  ; docker-compose up --remove-orphans -d workspace
# down:  ; docker-compose down
# build:  ; docker-compose build
# push:   ; docker-compose push
# shell:  ; docker-compose exec workspace zsh

update: build push
build:  ; docker build -t nonfiction/workspace .
push:   ; docker push nonfiction/workspace
shell:	; docker run -it --rm nonfiction/workspace zsh
