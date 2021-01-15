IMAGE_NAME := panubo/ansible
TAG := latest

.PHONY: build push clean run update _update

build: ## Builds the image
	docker build -t $(IMAGE_NAME):latest .

push:
	docker tag $(IMAGE_NAME):latest $(IMAGE_NAME):$(TAG)
	docker push $(IMAGE_NAME):$(TAG)

clean:
	docker rmi $(IMAGE_NAME):latest $(IMAGE_NAME):$(TAG) || true

playbooks/:
	mkdir -p playbooks

run: playbooks/ ## Runs a shell in the image
	docker run --rm -it -v $(PWD)/playbooks:/home/ansible/playbooks $(IMAGE_NAME):latest sh

update: ## Updates ansible and dependencies in Pipfile.lock
	docker run --user root --rm -it -v $(PWD):$(PWD) --workdir $(PWD) $(IMAGE_NAME):latest make _update
	$(MAKE) build

# This target should only be run inside a container
_update:
	apk --no-cache add --virtual .build-deps gcc g++
	pipenv lock

NEW_TAG := $(shell jq -r '.default.ansible.version' Pipfile.lock | sed 's/^==//')
tag: ## Creates a git tag based on the ansible version
	git tag v$(NEW_TAG)
