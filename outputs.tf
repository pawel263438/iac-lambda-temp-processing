# outputs.tf
output "group_lambda_arn" {
  value = module.group_lambda_function.lambda_function_arn
}

output "average_lambda_arn" {
  value = module.average_lambda_function.lambda_function_arn
}

output "secrets_lambda_arn" {
  value = module.group_lambda_function.lambda_function_arn
}

output "state_machine_arn" {
  value = module.step_function.state_machine_arn
}
