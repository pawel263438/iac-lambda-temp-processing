variable "function_name" {}
variable "role_arn" {}
variable "handler" {}
variable "runtime" {}
variable "filename" {}
variable "source_dir" {}
variable "environment_variables" {
  type = map(string)
}
variable "memory_size" {}
variable "timeout" {}
variable "reserved_concurrent_executions" {}

