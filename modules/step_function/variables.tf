variable "name" {
  description = "Name of the state machine"
  type        = string
}

variable "role_arn" {
  description = "IAM role ARN for the state machine"
  type        = string
}

variable "group_lambda_arn" {
  description = "ARN of the group lambda function"
  type        = string
}

variable "average_lambda_arn" {
  description = "ARN of the average lambda function"
  type        = string
}
