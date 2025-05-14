resource "aws_sfn_state_machine" "this" {
  name     = var.name
  role_arn = var.role_arn

  definition = jsonencode({
    Comment = "Parallel execution for 2 data branches",
    StartAt = "Group Data",
    States = {
      "Group Data" = {
        Type     = "Task",
        Resource = var.group_lambda_arn,
        Next     = "Parallel Processing"
      },
      "Parallel Processing" = {
        Type = "Parallel",
        Branches = [
          for i in range(5) : {
            StartAt = "Lambda Branch ${i + 1}",
            States = {
              "Lambda Branch ${i + 1}" = {
                Type      = "Task",
                Resource  = var.average_lambda_arn,
                InputPath = "$.parallel_inputs[${i}]",
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
