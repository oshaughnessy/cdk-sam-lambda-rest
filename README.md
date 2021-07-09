# cdk-sam-lambda-rest Demonstrating a serverless REST service using AWS CDK, AWS SAM, and AWS Lambda


# Dev prerequisites

* [CDK](https://docs.aws.amazon.com/cdk/latest/guide/getting_started.html#getting_started_install):

        npm install aws-cdk

* [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html)

        brew install awscli

* [SAM CLI beta](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-cdk-getting-started.html)

        brew tap aws/tap
        brew install aws/tap/aws-sam-cli-beta-cdk

* [Docker](https://docs.docker.com/docker-for-mac/install/)

    * ensure [file sharing](https://docs.docker.com/docker-for-mac/#file-sharing) is enabled

# Dev steps

## Initialize CDK project

    cdk init --language python
    source .venv/bin/activate
    pip install -r requirements.txt

##  Add a goss test

First we need to ensure the local service is running.
Assuming our Lambda and CDK code is working:

	sam-beta-cdk local start-api

Then, in another terminal, add a Goss HTTP test:

    # on a Mac, we're using an alpha release of https://goss.rocks/:
    export GOSS_USE_ALPHA=1

    # add a test of our local SAM-based HTTP service to goss.yaml
    goss add http --insecure http://localhost:3000/

    # run the test again
    goss validate
