import json
import os
import boto3


def get_table():
    dynamodb = boto3.resource(
        "dynamodb",
        region_name=os.environ.get("AWS_REGION", "ap-south-1")
    )
    return dynamodb.Table(os.environ["TABLE_NAME"])


def lambda_handler(event, context):
    try:
        table = get_table()

        response = table.update_item(
            Key={"id": "visits"},
            UpdateExpression="SET #count = if_not_exists(#count, :start) + :inc",
            ExpressionAttributeNames={"#count": "count"},
            ExpressionAttributeValues={":inc": 1, ":start": 0},
            ReturnValues="UPDATED_NEW",
        )

        new_count = int(response["Attributes"]["count"])

        return {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
            "body": json.dumps({"count": new_count}),
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)}),
        }
