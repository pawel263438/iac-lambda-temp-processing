provider "aws" {
  region = "us-east-1"  
}


data "aws_iam_role" "existing_lambda_role" {
  name = "LabRole"  # <- tu podaj nazwę roli, którą masz w AWS
}


module "group_lambda_function" {
  source = "./modules/lambda_function"

  function_name = "groupLambdaFunction"
  role_arn      = data.aws_iam_role.existing_lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  filename      = "group_lambda.zip"
  source_dir    = "${path.root}/lambda_code_group"

  environment_variables = {
    S3_BUCKET = "danepobranee"
    S3_KEY    = "sensor-1k.csv"
  }

  memory_size                   = 256
  timeout                       = 20
  reserved_concurrent_executions = 1
}

module "average_lambda_function" {
  source = "./modules/lambda_function"

  function_name = "averageLambdaFunction"
  role_arn      = data.aws_iam_role.existing_lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  filename      = "average_lambda.zip"
  source_dir    = "${path.root}/lambda_code_average"

  environment_variables = {
    S3_BUCKET = "danepobranee"
    S3_KEY    = "sensor-1k.csv"
  }

  memory_size                   = 256
  timeout                       = 20
  reserved_concurrent_executions = 5
}




terraform {
  backend "s3" {
    bucket         = "statebucketawsacademy"   # Zamień na swoją nazwę bucketu S3
    key            = "state/terraform.tfstate"
    region         = "us-east-1"          # Wybierz odpowiednią strefę
    encrypt        = true
    dynamodb_table = "terraform-locks"    # Tablica DynamoDB do blokowania stanu
    acl            = "bucket-owner-full-control"
  }
}
