LOCAL_URL=http://127.0.0.1:3000/

root_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
export PYENV_VERSION=3.8.11
export PYENV_ROOT=$(root_dir)/.pyenv
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
PYENV_VIRTUALENV=cdk-sam-lambda-rest
export GOSS_USE_ALPHA=1

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
	echo ""

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
	pip3 install --upgrade pip; \
	pip3 install --upgrade -r requirements.txt

lint:  ## check syntax of python code
	@echo "Checking Python code for syntax errors (fatal)"
	@$(call venv); pylint --errors-only cdklib lambda;
	@echo "Checking Python code for syntax suggestions (non-fatal)"
	@$(call venv); pylint --exit-zero cdklib lambda

test:  unittest   ## run local tests

unittest:  ## run pytest
	@$(call venv); \
	pytest -v --maxfail=1 --log-cli-level DEBUG lambda

goss-local:  local-endpoint  ## run goss local checks (requires `make start-api` running elsewhere)
	@printf "# Validating local deployment: $(ENDPOINT)\n\n"
	@goss validate --format documentation
	@printf -- "----\n\n"

goss-remote:  stack-endpoint  ## run goss remote checks (requires `make deploy` to complete successfully)
	@printf "Validating stack deployment: $(ENDPOINT)\n\n"
	@goss validate --format documentation
	@printf -- "----\n\n"


bootstrap:  ## initialize CDK resources in AWS
	@$(call venv); \
	cdk bootstrap

build:  ## build local SAM container
	@$(call venv); \
	sam-beta-cdk build

deploy:  ## deploy resources to AWS with CDK
	@$(call venv); \
	cdk deploy --app .aws-sam/build --outputs-file stack-outputs.json

validate: check-endpoint goss-remote  ## test the deployed service

local-endpoint:
	$(eval export ENDPOINT="http://localhost:3000/")

stack-endpoint:
	$(eval export ENDPOINT=$(shell jq -r .CdkSamLambdaRestStack.endpoint < stack-outputs.json))

check-endpoint: stack-endpoint
	@printf "# HTTP response from $(ENDPOINT):\n\n"
	@curl -ski -o- $(ENDPOINT) && echo ""
	@printf -- "----\n\n"

endpoint: stack-endpoint  ## Show the Lambda's HTTP endpoint URL
	@echo "Service endpoint: $$ENDPOINT"

.PHONY: lint test unittest goss bootstrap
