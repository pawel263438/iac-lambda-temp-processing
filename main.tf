provider "aws" {
  region = "us-east-1"  
}


data "aws_iam_role" "existing_lambda_role" {
  name = "LabRole"  # <- tu podaj nazwę roli, którą masz w AWS
}

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


resource "aws_lambda_function" "average_lambda" {
  function_name = "averageLambdaFunction"
  role          = data.aws_iam_role.existing_lambda_role.arn
  handler       = "lambda/average_lambda.lambda_handler"
  runtime       = "python3.8"

  filename      = "lambda/average_lambda.zip"
  source_code_hash = filebase64sha256("lambda/average_lambda.zip")
}



resource "aws_sfn_state_machine" "step_flow" {
  name     = "MyTwoStepMachine"
  role_arn = data.aws_iam_role.existing_lambda_role.arn

  definition = jsonencode({
    Comment = "Parallel execution for 2 data branches",
    StartAt = "Group Data",
    States = {
      "Group Data" = {
        Type     = "Task",
        Resource = aws_lambda_function.group_lambda.arn,
        Next     = "Parallel Processing"
      },
      "Parallel Processing" = {
        Type = "Parallel",
        Branches = [
          {
            StartAt = "Lambda Branch 1",
            States = {
              "Lambda Branch 1" = {
                Type      = "Task",
                Resource  = aws_lambda_function.average_lambda.arn,
                InputPath = "$.parallel_inputs[0]",
                End       = true
              }
            }
          },
          {
            StartAt = "Lambda Branch 2",
            States = {
              "Lambda Branch 2" = {
                Type      = "Task",
                Resource  = aws_lambda_function.average_lambda.arn,
                InputPath = "$.parallel_inputs[1]",
                End       = true
              }
            }
          },
	          {
            StartAt = "Lambda Branch 3",
            States = {
              "Lambda Branch 3" = {
                Type      = "Task",
                Resource  = aws_lambda_function.average_lambda.arn,
                InputPath = "$.parallel_inputs[2]",
                End       = true
              }
            }
          },
	          {
            StartAt = "Lambda Branch 4",
            States = {
              "Lambda Branch 4" = {
                Type      = "Task",
                Resource  = aws_lambda_function.average_lambda.arn,
                InputPath = "$.parallel_inputs[3]",
                End       = true
              }
            }
          },
          {
            StartAt = "Lambda Branch 5",
            States = {
              "Lambda Branch 5" = {
                Type      = "Task",
                Resource  = aws_lambda_function.average_lambda.arn,
                InputPath = "$.parallel_inputs[4]",
                End       = true
              }
            }
          }
        ],
        End = true
      }
    }
  })
}




 # assume_role_policy = jsonencode({
 #   Version = "2012-10-17"
 #   Statement = [
 #     {
 #       Action    = "sts:AssumeRole"
 #       Effect    = "Allow"
 #       Principal = {
 #         Service = "lambda.amazonaws.com"
 #       }
 #     },
 #   ]
 # })
#}