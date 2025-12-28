import json
import os
from unittest.mock import MagicMock, patch

from backend.lambda_function import handler


def test_lambda_handler_success():
    """Test successful visitor count increment"""

    os.environ["TABLE_NAME"] = "visitor-count"

    mock_table = MagicMock()
    mock_table.update_item.return_value = {
        "Attributes": {"count": 10}
    }

    with patch("backend.lambda_function.handler.get_table", return_value=mock_table):
        response = handler.lambda_handler({}, {})
        body = json.loads(response["body"])

        assert response["statusCode"] == 200
        assert body["count"] == 10
        assert response["headers"]["Content-Type"] == "application/json"
        assert response["headers"]["Access-Control-Allow-Origin"] == "*"


def test_lambda_handler_dynamodb_exception():
    """Test Lambda behavior when DynamoDB throws an error"""

    os.environ["TABLE_NAME"] = "visitor-count"

    mock_table = MagicMock()
    mock_table.update_item.side_effect = Exception("DynamoDB error")

    with patch("backend.lambda_function.handler.get_table", return_value=mock_table):
        response = handler.lambda_handler({}, {})
        body = json.loads(response["body"])

        assert response["statusCode"] == 500
        assert "DynamoDB error" in body["error"]
