"""Module that defines a CDK app for the demo service"""

import aws_cdk.core
from . import constructs


class CdkSamLambdaRestStack(aws_cdk.core.Stack):
    """Define a CDK stack that manages the message service"""

    def __init__(self, scope: aws_cdk.core.Construct, construct_id: str, **kwargs) -> None:
        """Initialize a new CdkSamLambdaRestStack CDK stack"""

        super().__init__(scope, construct_id, **kwargs)

        # Add our MessageService to the stack
        self.service = constructs.MessageService(self, 'Messages')

        # Create a stack output to share the API Gateway's endpoint URL
        aws_cdk.core.CfnOutput(self, 'endpoint',
            value=self.service.apigw.url
        )
