###### add it to data.tf
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file  = "${path.module}/../lambda_function/handler.py"
  output_path = "${path.module}/../lambda_function/function.zip"
}
#######################

resource "aws_lambda_function" "visitor_counter" {
  function_name = "${var.project_name}-lambda"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.10"

  # IMPORTANT: your file is handler.py, not app.py
  handler = "handler.lambda_handler"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.visitor_count.name
    }
  }

  depends_on = [data.archive_file.lambda_zip]
}

resource "aws_lambda_permission" "api_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.visitor_counter.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}
