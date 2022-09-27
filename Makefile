TTY?=-it
STOP_ON_FAILURE?=false
DOCKER_COMPOSE_CMD=$(shell echo 'docker-compose')
DOCKER_DEPENDENCY_CONTAINER_COMMAND=$(shell echo 'docker run --rm $(TTY) -e "TERM=xterm-256color"')
DOCKER_TAG=${DOCKER_TAG}

stop_on_failure:
	$(eval STOP_ON_FAILURE=true)

clear:
	$(DOCKER_COMPOSE_CMD) run --rm --entrypoint "/bin/sh -c" php 'bin/console cache:clear --no-warmup' || if [ $(STOP_ON_FAILURE) = true ]; then exit 1 ; fi
	$(DOCKER_COMPOSE_CMD) run --rm --entrypoint "/bin/sh -c" php 'chmod 777 var/* -R' || if [ $(STOP_ON_FAILURE) = true ]; then exit 1 ; fi

starter_kit_install:
	$(DOCKER_COMPOSE_CMD) run --rm starter_kit yarn

up: docker-compose.yaml
	$(DOCKER_COMPOSE_CMD) up -d

down:
	$(DOCKER_COMPOSE_CMD) down

restart: down up

starter_kit_shell:
	$(DOCKER_DEPENDENCY_CONTAINER_COMMAND) -it -v $$(pwd):/usr/src/app -w /usr/src/app/starter_kit node:14-alpine sh || if [ $(STOP_ON_FAILURE) = true ]; then exit 1 ; fi

lint_starter_kit:
	$(DOCKER_COMPOSE_CMD) run --rm --no-deps starter_kit sh -c 'yarn && yarn lint:fix --quiet'

prettier_starter_kit:
	$(DOCKER_COMPOSE_CMD) run --rm --no-deps starter_kit sh -c 'yarn && yarn prettier'

# BUILD
build_starter_kit: starter_kit_install
	$(DOCKER_COMPOSE_CMD) run --rm \
		starter_kit yarn build

.DEFAULT:
	@sh -c 'exit 0'
