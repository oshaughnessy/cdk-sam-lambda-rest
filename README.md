# cdk-sam-lambda-rest

This is a small project that demonstrates how to deploy a lightweight,
serverless REST microservice using AWS CDK, AWS SAM, AWS API Gateway V2,
and AWS Lambda.


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

[Pytest](https://pytest.org/) is used for some simple unit testing of the Lambda code.

[Goss](https://goss.rocks/) is used for deployment validation -- useful for local and AWS deployments.


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
