"""Module that defines a CDK app for the demo service"""

import aws_cdk.core
from . import cdk_sam_lambda_rest


class CdkSamLambdaRestStack(aws_cdk.core.Stack):
    """Define a CDK stack that manages the message service"""

    def __init__(self, scope: aws_cdk.core.Construct, construct_id: str, **kwargs) -> None:
        """Initialize a new CdkSamLambdaRestStack CDK stack"""

        super().__init__(scope, construct_id, **kwargs)

        # The code that defines your stack goes here
        cdk_sam_lambda_rest.MessageService(self, 'Messages')
