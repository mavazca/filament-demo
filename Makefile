# Para instalar o make, use: sudo apt install -y make

# Subir os containers
up:
	docker compose -f docker-compose.dev.yml up -d --force-recreate

# Para os containers
down:
	docker compose -f docker-compose.dev.yml down

# Reinicia os containers
restart:
	docker compose -f docker-compose.dev.yml restart

# Builda a imagem Docker
build:
	docker compose -f docker-compose.dev.yml build

# Ver os containers em execução
ps:
	docker compose -f docker-compose.dev.yml ps

# Acessa o container da aplicação
bash:
	docker compose -f docker-compose.dev.yml exec app bash

# Roda as migrations
migrate:
	docker compose -f docker-compose.dev.yml exec app php artisan migrate

# Roda as seeds
seed:
	docker compose -f docker-compose.dev.yml exec app php artisan db:seed

# Limpa cache e recompila config
optimize:
	docker compose -f docker-compose.dev.yml exec app php artisan optimize

# Logs da aplicação
logs:
	docker compose -f docker-compose.dev.yml logs -f app

# Executa comandos dentro do container da aplicação
exec:
	docker compose -f docker-compose.dev.yml exec app

# Executa comandos do Composer dentro do container da aplicação
composer:
	docker compose -f docker-compose.dev.yml exec app composer $(filter-out $@,$(MAKECMDGOALS))

# Webhook para o Asaas
webhook:
	ultrahook asaas 80/api/webhooks/asaas
