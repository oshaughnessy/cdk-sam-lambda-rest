# cdk-sam-lambda-rest

This is a small project that demonstrates how to deploy a lightweight,
serverless REST microservice using AWS CDK, AWS SAM, AWS API Gateway V2,
and AWS Lambda.

Ultimately, it deploys a REST endpoint in Lambda that returns a simple
JSON message:

    {
      "message": "Automate all the things!",
      "timestamp": 1625868715
    }

The message is always the same. The timestamp is the number of seconds
since the UNIX epoch at the time of execution.


## Key Technologies

[AWS Lambda](https://docs.aws.amazon.com/lambda/latest/dg/python-handler.html)
is used to create a simple Python application that returns a message and a timestamp.

[AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-cdk-getting-started.html)
is used to provide a way to test the Lambda in your local environment (CDK support is in beta).

[AWS API Gateway V2](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-develop-integrations-lambda.html)
is used to create a RESTful HTTP interface to the Lambda.

[AWS CDK](https://aws.amazon.com/blogs/compute/better-together-aws-sam-and-aws-cdk/)
is used to define the Lambda and API Gateway infrastructure using
a minimal amount of code and enable deploying them to AWS.


## Supporting Characters

[GNU Make](https://www.gnu.org/software/make/manual/) is used to provide a simple interface to many of the commands.

[Pylint](https://pylint.org/) is used for some simple Python syntax checking.

[Pytest](https://pytest.org/) is used for some simple unit testing of the Lambda code.

[Goss](https://goss.rocks/) is used for deployment validation -- useful for local and AWS deployments.

[Pyenv](https://github.com/pyenv/pyenv) and [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv) are used to manage Python on the Mac

[Docker](https://docs.docker.com/get-docker/) enables SAM to run local containers
with your Lambda.


## Getting started

```
% make help
make targets:
    * dependencies deps: install dev dependencies
    * lint:              check syntax of python code
    * local-api:         run the API locally
    * local:             invoke the Lambda locally
    * request req:       submit a request to the local API service
    * requirements reqs: install python3 requirements
    * test:              run local tests
    * unittest:          run pytest
```

## Install dev dependencies and requirements

The instructions and Makefile targets here assume development
on a Mac with [Homebrew](https://brew.sh) installed.

For local development and eventual deployment, you'll need a handful
of utilities and python packages.

    make deps virtualenv reqs


## Test the code locally

Simple one-off test that invokes the latest Lambda code locally:

    make local

Check the code with pylint, ensuring it's valid Python3 and doesn't
have too many warnings:

    make lint

Start the local version of the API service:

    make local-api

With that running, check the local HTTP service with goss in another
shell terminal:

    make goss

You can use `Control-C` to exit the `make local-api` session.


## Deploy to AWS

Ensure you have AWS access credentials configured in an awscli profile.
It's handy to add all of this to a file, say `env.sh` (see `env.sh.example`):

    export AWS_DEFAULT_REGION=_preferred_region_
    export AWS_SECRET_ACCESS_KEY=_api_secret_
    export AWS_ACCESS_KEY_ID=_api_key_id_
    export CDK_DEFAULT_ACCOUNT=_aws_account_id_
    export CDK_DEFAULT_REGION=_preferred_region_

and then source it:

    source env.sh

Next, prepare your account for deployment and then deploy:

    make bootstrap build deploy

To validate, query the URL shown by the CDK and verify the response
contains both a "message" and "timestamp" field:

    curl _url_

TODO: should call goss here, reading the location of the URL to
test from a stack output, invoking it with `make validate`
