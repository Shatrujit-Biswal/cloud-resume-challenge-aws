import json
import os
import importlib
from unittest.mock import MagicMock, patch


def load_handler_with_env(mock_table):
    """
    Helper function to:
    - set env var
    - mock boto3
    - import/reload handler safely
    """
    os.environ["TABLE_NAME"] = "visitor-count"

    with patch("backend.lambda_function.handler.boto3.resource") as mock_boto:
        mock_boto.return_value.Table.return_value = mock_table

        from backend.lambda_function import handler

        importlib.reload(handler)

        return handler


def test_lambda_handler_success():
    """Test successful visitor count increment"""

    mock_table = MagicMock()
    mock_table.update_item.return_value = {
        "Attributes": {"count": 10}
    }

    handler = load_handler_with_env(mock_table)

    response = handler.lambda_handler({}, {})
    body = json.loads(response["body"])

    assert response["statusCode"] == 200
    assert body["count"] == 10
    assert response["headers"]["Content-Type"] == "application/json"
    assert response["headers"]["Access-Control-Allow-Origin"] == "*"

    mock_table.update_item.assert_called_once()


def test_lambda_handler_dynamodb_exception():
    """Test Lambda behavior when DynamoDB throws an error"""

    mock_table = MagicMock()
    mock_table.update_item.side_effect = Exception("DynamoDB error")

    handler = load_handler_with_env(mock_table)

    response = handler.lambda_handler({}, {})
    body = json.loads(response["body"])

    assert response["statusCode"] == 500
    assert "error" in body
    assert "DynamoDB error" in body["error"]
