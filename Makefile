LOCAL_URL=http://127.0.0.1:3000/

root_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
export PYENV_VERSION=3.8.11
export PYENV_ROOT=$(root_dir)/.pyenv
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
PYENV_VIRTUALENV=cdk-sam-lambda-rest

help:
	@echo make targets:
	@awk ' \
	    BEGIN { FS=":.*?## " } \
	    $$1~/^[A-Za-z]/ && $$2~/^.+/ { \
	        printf "    * %-18.18s %s\n",$$1":",$$2 \
	    }' $(MAKEFILE_LIST)

#	eval "$$(pyenv init -)"; \
#	eval "$$(pyenv virtualenv-init -)"; \

define venv
	source $(PYENV_ROOT)/versions/$(PYENV_VIRTUALENV)/bin/activate
endef

local:  ## invoke the Lambda locally
	$(call venv); \
	sam-beta-cdk local invoke CdkSamLambdaRestStack/MessagesHandler

local-api:  ## run the API locally
	$(call venv); \
	sam-beta-cdk local start-api

request req:  ## submit a request to the local API service
	@set -o pipefail; curl -s $(LOCAL_URL) |jq -Rr . \
	 || echo "Is the service running on $(LOCAL_URL)?\nTry \`make local-api\` in another terminal"

dependencies deps:  ## install dev dependencies
	hash aws || brew install awscli
	hash sam-beta-cdk || { brew tap aws/tap && brew install aws/tap/aws-sam-cli-beta-cdk; }
	hash cdk || npm install -g aws-cdk
	hash pyenv || brew install pyenv
	hash pyenv-virtualenv || brew install pyenv-virtualenv
	hash goss || { echo "Please install goss -- https://goss.rocks/"; }
	hash docker || { echo "Please install Docker -- https://docs.docker.com/get-docker/"; }

virtualenv:  ## install python 3 and create virtualenv
	pyenv install $(PYENV_VERSION)
	pyenv virtualenv $(PYENV_VERSION) $(PYENV_VIRTUALENV)

requirements reqs:   ## install python3 requirements
	$(call venv); \
	pip3 install -r requirements.txt

lint:  ## check syntax of python code
	@echo "Checking Python code for syntax errors (fatal)"
	@$(call venv); pylint --errors-only cdklib lambda;
	@echo "Checking Python code for syntax suggestions (non-fatal)"
	@$(call venv); pylint --exit-zero cdklib lambda

test:  unittest goss  ## run local tests

unittest:  ## run pytest
	@$(call venv); \
	pytest -v --maxfail=1 --log-cli-level DEBUG

goss:
	GOSS_USE_ALPHA=1 goss validate


bootstrap:
	@$(call venv); \
	cdk bootstrap

build:
	@$(call venv); \
	sam-beta-cdk build

deploy:
	@$(call venv); \
	cdk deploy -a .aws-sam/build


.PHONY: lint test unittest goss bootstrap
