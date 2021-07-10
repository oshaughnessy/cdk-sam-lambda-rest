"""Module that defines CDK resources for the demo service"""

# pylint: disable=line-too-long

import aws_cdk.core
import aws_cdk.aws_apigatewayv2
import aws_cdk.aws_apigatewayv2_integrations
import aws_cdk.aws_lambda


class MessageService(aws_cdk.core.Construct):
    """Define a CDK construct that includes Lambda and API Gateway"""

    def __init__(self, scope: aws_cdk.core.Construct, name: str):
        """Initialize a new MessageService construct"""

        super().__init__(scope, name)

        self.handler = aws_cdk.aws_lambda.Function(self, 'MessagesHandler',
            runtime=aws_cdk.aws_lambda.Runtime.PYTHON_3_8,
            code=aws_cdk.aws_lambda.Code.from_asset('lambda'),
            handler='handler.main',
            environment=dict()
        )

        # ref: https://docs.aws.amazon.com/cdk/api/latest/python/aws_cdk.aws_apigatewayv2/README.html
        self.integration = aws_cdk.aws_apigatewayv2_integrations.LambdaProxyIntegration(
            handler=self.handler
        )

        self.apigw = aws_cdk.aws_apigatewayv2.HttpApi(self, 'messages-api',
            description='This service returns a message with a timestamp'
        )
        self.apigw.add_routes(
            path='/',
            methods=[aws_cdk.aws_apigatewayv2.HttpMethod.GET],
            integration=self.integration
        )
