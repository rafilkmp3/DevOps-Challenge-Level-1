# import deploy config
# You can change the default deploy config with `make cnf="deploy_special.env" release`
dpl ?= deploy.env
include $(dpl)
export $(shell sed 's/=.*//' $(dpl))

# grep the version from git
VERSION=$(shell ./version-up.sh  --patch --release | grep "TAG" | awk '{split($$0, a, ":"); print a[2]}' | sed 's/\x1b\[[0-9;]*m//g' | sed -e 's/^[[:space:]]*//')

PLATFORM := "linux/amd64,linux/arm/v7,linux/arm64"
# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


# Build the container
build:
	docker buildx build \
		--output "type=docker" \
		--tag $(DOCKER_REPO)/$(APP_NAME):latest .

# Build and run the container
up: build ## Spin up the project
	docker run -i -t --rm --env-file=./deploy.env -p=$(APP_PORT):$(APP_PORT) --name="$(APP_NAME)" $(DOCKER_REPO)/$(APP_NAME):latest

stop: ## Stop running containers
	docker stop $(APP_NAME)

build-multi-arch-latest:
	@docker buildx create --use --name=multiarch --node multiarch && \
	docker buildx build \
		--progress=plain \
		--platform $(PLATFORM) \
		--output "type=image,push=false" \
		--tag $(DOCKER_REPO)/$(APP_NAME):latest .

build-multi-arch-version:
	@docker buildx create --use --name=multiarch --node multiarch && \
	docker buildx build \
		--progress=plain \
		--platform $(PLATFORM) \
		--output "type=image,push=false" \
		--tag $(DOCKER_REPO)/$(APP_NAME):$(VERSION) .

publish-latest: ## publish the `latest` tagged container to Registry
	@echo 'publish latest to $(DOCKER_REPO)'
	@docker buildx create --use --name=multiarch --node multiarch && \
	docker buildx build \
		--progress=plain \
		--platform $(PLATFORM) \
		--output "type=image,push=true" \
		--tag $(DOCKER_REPO)/$(APP_NAME):latest .

publish-version:## publish the calculated tagged container to Registry
	@docker buildx create --use --name=multiarch --node multiarch && \
	docker buildx build \
		--progress=plain \
		--platform $(PLATFORM) \
		--output "type=image,push=true" \
		--tag $(DOCKER_REPO)/$(APP_NAME):$(VERSION) .

# Docker publish
.PHONY: publish
publish: publish-latest publish-version ## publish the `{version}` ans `latest` tagged containers to GHCR
	@echo 'publish latest and $(VERSION) tag'
# HELPERS
# THIS IS NOT WORKING YET login must be done manually

# generate script to login to aws docker repo
CMD_REPOLOGIN := "echo -n  $(GITHUB_TOKEN) | docker login -u $(GHCR_USERNAME) --password-stdin  ghcr.io"

repo-login: ## Auto login to ghcr
	@eval $(CMD_REPOLOGIN)

version: ## output to version
	@echo $(VERSION)
