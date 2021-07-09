from . import handler
import datetime
import pytest


def test_handler_message():
    """Ensure the Lambda handler's message starts with 'Automate'"""
    assert handler.event_message().startswith("Automate")


def test_handler_timestamp_default_time():
    """Ensure the Lambda handler's timestamp funcdtion returns the current time"""
    now = datetime.datetime.now()
    timestamp = handler.event_timestamp({})
    print(f"timestamp={timestamp}, now={now.timestamp()}")
    assert timestamp-int(now.timestamp()) < 5


def test_handler_timestamp_event_time():
    """Ensure the Lambda handler's timestamp funcdtion returns the epoch time from the given event"""
    epoch_timestamp = '1625816819'
    handler_timestamp = handler.event_timestamp({
        'requestContext': {
            'timeEpoch': epoch_timestamp
        }
    })
    assert epoch_timestamp == handler_timestamp


def test_handler_response_message_key():
    """Ensure the Lambda handler's response includes a message key"""
    assert 'message' in handler.main({}, {})


def test_handler_response_timestamp_key():
    """Ensure the Lambda handler's response includes a message key"""
    assert 'timestamp' in handler.main({}, {})

