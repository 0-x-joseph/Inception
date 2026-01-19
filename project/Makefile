LOGIN      = joseph
VOLUME_DIR = /home/$(LOGIN)/data
MARIADB_VOLUME = $(VOLUME_DIR)/mariadb
WP_VOLUME = $(VOLUME_DIR)/wordpress
COMPOSE_FILE = ./srcs/docker-compose.yml
DC = docker compose -f $(COMPOSE_FILE)

all: up

volumes:
	@mkdir -p $(VOLUME_DIR)

up: volumes
	@$(DC) up -d --build

down:
	@$(DC) down

re: down up

clean: down
	@$(DC) down --remove-orphans

fclean: down
	@$(DC) down --rmi all -v --remove-orphans
	@sudo rm -rf $(WP_VOLUME) $(MARIADB_VOLUME)

.PHONY: all volumes up down re clean fclean
