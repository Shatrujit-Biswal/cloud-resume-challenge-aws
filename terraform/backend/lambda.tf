resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "time_sleep" "wait_for_iam" {
  depends_on = [
    aws_iam_role_policy_attachment.attach_policy,
    aws_iam_role_policy_attachment.lambda_basic
  ]
  create_duration = "20s"
}

resource "aws_lambda_function" "visitor_counter" {
  function_name = "${var.project_name}-lambda"
  role          = aws_iam_role.lambda_role.arn

  runtime = "python3.10"
  handler = "handler.lambda_handler"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.visitor_count.name
    }
  }

  depends_on = [
    data.archive_file.lambda_zip,
    time_sleep.wait_for_iam
  ]
}

resource "aws_lambda_permission" "api_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.visitor_counter.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}
