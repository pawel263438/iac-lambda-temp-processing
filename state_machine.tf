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
