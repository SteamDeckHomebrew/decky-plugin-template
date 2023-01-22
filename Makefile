ifneq (,$(wildcard ./.env))
	include .env
	export
endif

SHELL=bash

.PHONY: help
help: ## Display list of tasks with descriptions
	@echo "+ $@"
	@fgrep -h ": ## " $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed 's/-default//' | awk 'BEGIN {FS = ": ## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: vendor
vendor: ## Install project dependencies
	@echo "+ $@"
	@pnpm i

.PHONY: env
env: ## Create default .env file
	@echo "+ $@"
	@echo -e '# Makefile tools\nDECK_USER=deck\nDECK_HOST=192.168.0.22\nDECK_PORT=22\nDECK_HOME=/home/deck\nDECK_KEY=~/.ssh/id_rsa' >> .env
	@echo -n "PLUGIN_FOLDER=" >> .env
	@jq -r .name package.json >> .env

.PHONY: init
init: ## Initialize project
init: env vendor
	@echo -e "\n\033[1;36m Almost ready! Just a few things left to do:\033[0m\n"
	@echo -e "1. Open .env file and make sure every DECK_* variable matches your steamdeck's ip, user, etc"
	@echo -e "2. Run \`\033[0;36mmake copy-ssh-key\033[0m\` to copy your public ssh key to steamdeck"
	@echo -e "3. Build your code with \`\033[0;36mmake build\033[0m\` or \`\033[0;36mmake docker-build\033[0m\` to build inside a docker container"
	@echo -e "4. Deploy your plugin code to steamdeck with \`\033[0;36mmake deploy\033[0m\`"

.PHONY: update-frontend-lib
update-frontend-lib: ## Update decky-frontend-lib
	@echo "+ $@"
	@pnpm update decky-frontend-lib --latest

.PHONY: build-front
build-front: ## Build frontend
	@echo "+ $@"
	@pnpm run build

.PHONY: build-back
build-back: ## Build backend
	@echo "+ $@"
	@make -C ./backend

.PHONY: build
build: ## Build everything
build: build-front build-back

.PHONY: copy-ssh-key
copy-ssh-key: ## Copy public ssh key to steamdeck
	@echo "+ $@"
	@ssh-copy-id -i $(DECK_KEY) $(DECK_USER)@$(DECK_HOST)

.PHONY: deploy-steamdeck
deploy-steamdeck: ## Deploy plugin build to steamdeck
	@echo "+ $@"
	@ssh $(DECK_USER)@$(DECK_HOST) -p $(DECK_PORT) -i $(DECK_KEY) \
 		'chmod -v 755 $(DECK_HOME)/homebrew/plugins/ && mkdir -p $(DECK_HOME)/homebrew/plugins/$(PLUGIN_FOLDER)'
	@rsync -azp --delete --progress -e "ssh -i $(DECK_KEY)" \
		--chmod=Du=rwx,Dg=rx,Do=rx,Fu=rwx,Fg=rx,Fo=rx \
		--exclude='.git/' \
		--exclude='.github/' \
		--exclude='.vscode/' \
		--exclude='node_modules/' \
		--exclude='.pnpm-store/' \
		--exclude='src/' \
		--exclude='*.log' \
		--exclude='.gitignore' . \
		--exclude='.idea' . \
		--exclude='.env' . \
		--exclude='Makefile' . \
 		./ $(DECK_USER)@$(DECK_HOST):$(DECK_HOME)/homebrew/plugins/$(PLUGIN_FOLDER)/
	@ssh $(DECK_USER)@$(DECK_HOST) -p $(DECK_PORT) -i $(DECK_KEY) \
 		'chmod -v 755 $(DECK_HOME)/homebrew/plugins/'

.PHONY: restart-decky
restart-decky: ## Restart Decky on remote steamdeck
	@echo "+ $@"
	@ssh -t $(DECK_USER)@$(DECK_HOST) -p $(DECK_PORT) -i $(DECK_KEY) \
 		'sudo systemctl restart plugin_loader.service'
	@echo -e '\033[0;32m+ all is good, restarting Decky...\033[0m'

.PHONY: deploy
deploy: ## Deploy code to steamdeck and restart Decky
deploy: deploy-steamdeck restart-decky

.PHONY: it
it: ## Build all code, deploy it to steamdeck, restart Decky
it: build deploy

.PHONY: cleanup
cleanup: ## Delete all generated files and folders
	@rm -f .env
	@rm -rf ./dist
	@rm -rf ./tmp
	@rm -rf ./node_modules
	@rm -rf ./.pnpm-store
	@rm -rf ./backend/out

.PHONY: uninstall-plugin
uninstall-plugin: ## Uninstall plugin from steamdeck, restart Decky
	@echo "+ $@"
	@ssh -t $(DECK_USER)@$(DECK_HOST) -p $(DECK_PORT) -i $(DECK_KEY) \
 		"sudo sh -c 'rm -rf $(DECK_HOME)/homebrew/plugins/$(PLUGIN_FOLDER)/ && systemctl restart plugin_loader.service'"
	@echo -e '\033[0;32m+ all is good, restarting Decky...\033[0m'

.PHONY: docker-init
docker-init: ## Initialize project inside docker container
docker-init: docker-rebuild-image
	@echo "+ $@"
	@docker compose run --rm tools make init

.PHONY: docker-rebuild-image
docker-rebuild-image: ## Rebuild docker image
	@echo "+ $@"
	@docker compose build --pull

.PHONY: docker-build
docker-build: ## Build project inside docker container
	@echo "+ $@"
	@docker compose run --rm tools make build
