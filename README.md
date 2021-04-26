# nonfiction Workspace

Workspace environment for web development, including:

- [Alpine Linux](https://alpinelinux.org)
- [VS Code](https://github.com/cdr/code-server)
- [npm](https://www.npmjs.com) 
- [webpack](https://webpack.js.org)
- [Ruby](https://www.ruby-lang.org/en/)
- [Thor](https://github.com/erikhuda/thor)
- [MariaDB Client](https://mariadb.com/kb/en/mysql-client/)
- [OpenSSH](https://www.openssh.com)
- [PHP](https://www.php.net)
- [Composer](https://getcomposer.org)
- [Docker](https://docs.docker.com/engine/)
- [Docker Compose](https://docs.docker.com/compose/)

## Create work directory on host:  

`sudo mkdir -p /work`  

## Create .env and populate values:  

`cp example.env .env`  


## Makefile commands:  

```
make build
make up
make down
make push
make shell
```
