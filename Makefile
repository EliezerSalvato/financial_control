SHELL := $(shell which bash)

build:
	docker-compose up -d --build

start:
	docker-compose up -d

stop:
	docker-compose down

createdb:
	docker exec financial_control sh -c 'rails db:create'

dropdb:
	docker exec financial_control sh -c 'rails db:drop'

migrate:
	docker exec financial_control sh -c 'rails db:migrate'

logs:
	docker exec financial_control sh -c 'tail -f log/development.log'

bash:
	docker exec -it financial_control /bin/bash

firstrun:
	make createdb
	make migrate
