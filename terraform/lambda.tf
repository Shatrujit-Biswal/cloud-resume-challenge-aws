resource "aws_lambda_function" "visitor_counter" {
  function_name = "${var.project_name}-lambda"
  role          = aws_iam_role.lambda_role.arn

  runtime = "python3.10"
  handler = "handler.lambda_handler"

  # Terraform creates the Lambda shell only.
  # Application code is deployed via CI/CD.
  filename = "bootstrap.zip"

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.visitor_count.name
    }
  }
}

resource "aws_lambda_permission" "api_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.visitor_counter.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}
