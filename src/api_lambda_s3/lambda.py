import json
from decimal import Decimal

def default(obj):
    if isinstance(obj, Decimal):
        return str(obj)
    raise TypeError("Object of type '%s' is not JSON serializable" % type(obj).__name__)

def lambda_handler(event, context):
    resp = {
        "message": "Hello S3 Tommy",
    }

    return {
        'statusCode': 200,
        'body' : json.dumps(resp, default=default)
    }