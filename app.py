#!/usr/bin/env python3
import os

import aws_cdk.core
import cdklib.stack


app = aws_cdk.core.App()

aws_account = os.getenv('CDK_DEFAULT_ACCOUNT', default=None)
aws_region = os.getenv('CDK_DEFAULT_REGION', default=None)
cdklib.stack.CdkSamLambdaRestStack(app, 'CdkSamLambdaRestStack',
    # ref: https://docs.aws.amazon.com/cdk/latest/guide/environments.html
    env=aws_cdk.core.Environment(
        account=aws_account,
        region=aws_region
    )
)

app.synth()
