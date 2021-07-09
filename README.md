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
