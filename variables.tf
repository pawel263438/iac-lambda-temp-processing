# variables.tf (w katalogu głównym)
variable "region" {
  default = "us-east-1"
}

variable "env" {
  default = "dev"
}


variable "db_password" {
  type      = string
  sensitive = true
}