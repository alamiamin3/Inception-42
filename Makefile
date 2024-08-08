all: build
build:
	sudo rm -rf /home/aalami/data/*
	mkdir -p /home/aalami/data/wordpress
	mkdir -p /home/aalami/data/mariadb
	docker compose -f ./srcs/docker-compose.yaml up --build -d
stop:
	docker compose -f ./srcs/docker-compose.yaml down
