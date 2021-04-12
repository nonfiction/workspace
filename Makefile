include .env 

up:  ; docker-compose up --remove-orphans -d workspace
down:  ; docker-compose down
build:  ; docker-compose build
shell:  ; docker-compose exec workspace zsh
