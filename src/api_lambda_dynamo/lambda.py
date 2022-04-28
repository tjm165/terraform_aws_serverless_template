import json
from decimal import Decimal
import boto3
from boto3.dynamodb.conditions import Key, Attr
from uuid import uuid4

def default(obj):
    if isinstance(obj, Decimal):
        return str(obj)
    raise TypeError("Object of type '%s' is not JSON serializable" % type(obj).__name__)

def lambda_handler(event, context):

    record_uuid = uuid4().hex

    dynamodb = boto3.resource('dynamodb', region_name='us-east-2').Table("ServerlessCoffeeShope")
    dynamodb.put_item(Item={
            'Id': record_uuid, 
            'Time': 1,
            'Color1': "abc",
            'Color2': "def"
    })


    result = dynamodb.get_item(Key={'Id': record_uuid})

    resp = {
        "message": "hello api_lambda_dynamo",
        "result": result
    }

    return {
        'statusCode': 200,
        'body' : json.dumps(resp, default=default)
    }