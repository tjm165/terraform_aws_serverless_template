import json
import boto3
from uuid import uuid4

def lambda_handler(event, context):

    dynamodb = boto3.resource('dynamodb', region_name='us-east-2').Table("ServerlessCoffeeOrders")
    dynamodb.put_item(Item={
            'Id': uuid4().hex, 
            'Time': 1,
            'Color1': "abc",
            'Color2': "def"
    })
# maybe add region for a fun range key?

    return {
        'statusCode': 200,
        'body' : json.dumps(event['headers']['X-Forwarded-For'])
    }