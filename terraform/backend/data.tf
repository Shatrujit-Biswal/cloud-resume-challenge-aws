data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../../backend/lambda_function/handler.py"
  output_path = "${path.module}/../../backend/lambda_function/function.zip"
}