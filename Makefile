include .env
export

export PROJECT_ROOT=$(shell pwd)

env-up:
	@docker compose up -d vpn-postgres

env-down:
	@docker compose down vpn-postgres

env-cleanup:
	@read -p "Очистить все volume файлы окружения? Опасность потери данных. [y/N]: " ans; \
	if [ "$$ans" = "y" ]; then \
		docker compose down -v vpn-postgres port-forwarder && \
		echo "Файлы окружения очищены"; \
	else \
		echo "Очистка окружения отменена"; \
	fi

env-port-forward:
	@docker compose up -d port-forwarder

env-port-close:
	@docker compose down port-forwarder

migrate-create:
	@if [ -z "$(seq)" ]; then \
		echo "Отсутствует необходимый параметр seq. Пример: make migrate-create seq=init"; \
		exit 1; \
	fi; \
	docker compose run --rm vpn-postgres-migrate \
		create \
		-ext sql \
		-dir /migrations \
		-seq "$(seq)"
	@$(MAKE) fix-perms-migrations

migrate-up:
	@$(MAKE) migrate-action action=up

migrate-down:
	@$(MAKE) migrate-action action=down

migrate-action:
	@if [ -z "$(action)" ]; then \
		echo "Отсутствует необходимый параметр action. Пример: make migrate-action action=up"; \
		exit 1; \
	fi; \
	if [ -n "$(n)" ] && ! echo "$(n)" | grep -Eq '^[1-9][0-9]*$$'; then \
		echo "Параметр n должен быть положительным целым числом"; \
		exit 1; \
	fi; \
	docker compose run --rm vpn-postgres-migrate \
		-path /migrations \
		-database "postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@vpn-postgres:5432/${POSTGRES_DB}?sslmode=disable" \
		"$(action)" $(if $(n),$(n))

fix-perms-migrations:
	@sudo chown -R $(shell id -u):$(shell id -g) migrations