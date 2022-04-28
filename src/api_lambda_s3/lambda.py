import json
from decimal import Decimal
import boto3

def default(obj):
    if isinstance(obj, Decimal):
        return str(obj)
    raise TypeError("Object of type '%s' is not JSON serializable" % type(obj).__name__)

def lambda_handler(event, context):
    s3 = boto3.resource('s3')
    bucket = s3.Bucket('serverlesscoffeeshops3')
    
    content = "<!DOCTYPE html><html><head><title>Serverless API Lambda S3</title></head><body><h1>Welcome to api_lambda_s3</h1><h2>The contents of this s3 bucket are</h2>"
    
    for obj in bucket.objects.all():
        content += "<p> /" + obj.key + "</p>"
        print(obj.key)
        
    content += "</body></html>"

    return {
        'statusCode': 200,
        'body' : content,
        "headers": {
            'Content-Type': 'text/html',
        }
    }