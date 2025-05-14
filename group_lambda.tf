resource "aws_lambda_function" "group_lambda" {
  function_name = "groupLambdaFunction"
  role          = data.aws_iam_role.existing_lambda_role.arn
  handler       = "lambda/group_lambda.lambda_handler"  
  runtime       = "python3.8"

 
  filename      = "lambda/group_lambda.zip"
  source_code_hash = filebase64sha256("lambda/group_lambda.zip")

  environment {
    variables = {
      S3BUCKET = "danepobranee"
      S3KEY    = "sensor-1k.csv"
    }
  }
}
