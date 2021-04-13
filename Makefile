include .env 

up:  ; docker-compose up --remove-orphans -d workspace
down:  ; docker-compose down
build:  ; docker-compose build
push:   ; docker-compose push
shell:  ; docker-compose exec workspace zsh
