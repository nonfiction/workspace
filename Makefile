update: build push
build:  ; docker buildx build -t nonfiction/workspace .
push:   ; docker push nonfiction/workspace
shell:	; docker run -it --rm nonfiction/workspace zsh
