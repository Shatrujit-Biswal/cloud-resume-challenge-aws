import os
from unittest.mock import MagicMock, patch

def test_lambda_handler_success():
    os.environ["TABLE_NAME"] = "visitor-count"

    mock_table = MagicMock()
    mock_table.update_item.return_value = {
        "Attributes": {"count": 10}
    }

    mock_dynamodb = MagicMock()
    mock_dynamodb.Table.return_value = mock_table

    with patch("boto3.resource", return_value=mock_dynamodb):
        import handler

        response = handler.lambda_handler({}, {})

        assert response["statusCode"] == 200
