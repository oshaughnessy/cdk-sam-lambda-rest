"""Module that defines an AWS Lambda function handler

Returns a python dict that ultimately is sent back
to the Lambda requestor as a JSON document:
- always returns HTTP success 
- response body includes 2 fields:
  * "message" containing a string
  * "timestamp" containing # seconds since the UNIX epoch (Jan 1, 1970)
"""

import datetime


def event_message() -> str:
    """Return the static message we use for all events"""
    return "Automate all the things!"


def event_timestamp(event: dict) -> str:
    """Return epoch time of the current event

    If event time info is available, use that.
    Otherwise, use the current time.
    """
    req_context = event.get('requestContext', {})
    return req_context.get('timeEpoch', int(datetime.datetime.now().timestamp()))


def main(event, context) -> dict:  # pylint: disable=unused-argument
    """Lambda entrypoint

    returns a dict with information for the Lambda response
    """

    return {
        'message': event_message(),
        'timestamp': event_timestamp(event)
    }
