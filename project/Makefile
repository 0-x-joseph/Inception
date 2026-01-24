DC = docker-compose -f ./srcs/docker-compose.yml

all: up

up:
	@$(DC) up -d --build

down:
	@$(DC) down

re: clean up

clean: down
	@$(DC) down --rmi local -v --remove-orphans

.PHONY: all up down re clean
