import json
import os
from unittest.mock import MagicMock, patch

# IMPORTANT:
# Import handler AFTER patching boto3.resource
# Do NOT import handler at top-level


def test_lambda_handler_success():
    os.environ["TABLE_NAME"] = "visitor-count"

    mock_table = MagicMock()
    mock_table.update_item.return_value = {
        "Attributes": {"count": 10}
    }

    mock_dynamodb = MagicMock()
    mock_dynamodb.Table.return_value = mock_table

    with patch("boto3.resource", return_value=mock_dynamodb):
        from backend.lambda_function import handler

        response = handler.lambda_handler({}, {})
        body = json.loads(response["body"])

        assert response["statusCode"] == 200
        assert body["count"] == 10
        assert response["headers"]["Content-Type"] == "application/json"
        assert response["headers"]["Access-Control-Allow-Origin"] == "*"

        mock_table.update_item.assert_called_once()


def test_lambda_handler_dynamodb_exception():
    os.environ["TABLE_NAME"] = "visitor-count"

    mock_table = MagicMock()
    mock_table.update_item.side_effect = Exception("DynamoDB error")

    mock_dynamodb = MagicMock()
    mock_dynamodb.Table.return_value = mock_table

    with patch("boto3.resource", return_value=mock_dynamodb):
        from backend.lambda_function import handler

        response = handler.lambda_handler({}, {})
        body = json.loads(response["body"])

        assert response["statusCode"] == 500
        assert "error" in body
        assert "DynamoDB error" in body["error"]
