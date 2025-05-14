resource "aws_lambda_function" "average_lambda" {
  function_name = "averageLambdaFunction"
  role          = data.aws_iam_role.existing_lambda_role.arn
  handler       = "lambda/average_lambda.lambda_handler"
  runtime       = "python3.8"

  filename      = "lambda/average_lambda.zip"
  source_code_hash = filebase64sha256("lambda/average_lambda.zip")
}