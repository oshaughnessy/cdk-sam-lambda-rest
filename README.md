# cdk-sam-lambda-rest

This is a small project that demonstrates how to deploy a lightweight,
serverless REST microservice using AWS CDK, AWS SAM, AWS API Gateway V2,
and AWS Lambda.

Ultimately, it deploys a REST endpoint in Lambda that returns a simple
JSON message:

    {
      "message": "Automation for the people!",
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

[Goss](https://goss.rocks/) is used for deployment validation -- useful for local and AWS deployments. &#x270a; Goss Rocks!

[Pyenv](https://github.com/pyenv/pyenv) and [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv) are used to manage Python on the Mac.

[Docker](https://docs.docker.com/get-docker/) enables SAM to run local containers
with your Lambda.

[aws-vault](https://github.com/99designs/aws-vault) for AWS credential management with good MFA support.


## Getting started

```
% make help
make targets:
    * local:             invoke the Lambda locally
    * local-api:         run the API locally
    * request req:       submit a request to the local API service
    * dependencies deps: install dev dependencies
    * virtualenv:        install python 3 and create virtualenv
    * requirements reqs: install python3 requirements
    * lint:              check syntax of python code
    * test:              run local tests
    * unittest:          run pytest
    * goss-local:        run goss local checks (requires `make start-api` running elsewhere)
    * goss-remote:       run goss remote checks (requires `make deploy` to complete successfully)
    * bootstrap:         initialize CDK resources in AWS
    * build:             build local SAM container
    * deploy:            deploy resources to AWS with CDK
    * validate:          test the deployed service
    * endpoint:          Show the Lambda's HTTP endpoint URL
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

    make goss-local

You can use `Control-C` to exit the `make local-api` session.


## Running in AWS

### Credentials

Ensure you have AWS access credentials configured in an awscli profile.
It's handy to add all of this to a file, say `env.sh` (see `env.sh.example`):

    export AWS_DEFAULT_REGION=_preferred_region_
    export AWS_SECRET_ACCESS_KEY=_api_secret_
    export AWS_ACCESS_KEY_ID=_api_key_id_
    export CDK_DEFAULT_ACCOUNT=_aws_account_id_
    export CDK_DEFAULT_REGION=_preferred_region_

and then source it:

    source env.sh

_Alternatively_ and arguably better, use 99designs' [aws-vault](https://github.com/99designs/aws-vault)
to set up a profile for your chosen AWS environment. The included Makefile assumes you have aws-vault
installed and set up. Define an AWS profile and the Makefile will do the rest:

    export AWS_PROFILE=some-proile-that-aws-vault-knows-about

### Deploy

Next, prepare your account for deployment and then deploy:

    make bootstrap build deploy

To validate, query the URL provided as a CDK stack output
and verify the response contains both a "message" and "timestamp" field:

    make validate

When you're all done, tear it down:

    make destroy


# What's Next?

This is essentially a tech demo. Even at that level, there are opportunities
for improvement:

* Add more documentation in the cdklib and lambda dirs to explain
  what is happening
* Add unit testing to the cdklib code; only the lambda code has tests now
* Add a GitHub Actions pipeline to deploy the stack to AWS
* Improve the installation and management of requirements.
  The toolchain required for CDK, SAM, and Python is a mess to install.
  The Makefile targets assume a Mac environment, but a GitHub Actions
  env won't target that. Doing everything within a Docker container
  would surely be simpler, and would probably still allow the use
  of SAM-local, but it wouldn't facilitate the use-case behind this
  exercise (breaking Lambda definitions out of CloudFormation templates
  embedded in Amazon Landing Zone add-ons), so I didn't choose that
  path initially.
