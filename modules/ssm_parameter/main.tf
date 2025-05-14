# modules/ssm_parameter/main.tf
resource "aws_ssm_parameter" "db_password" {
  name  = "/myapplication/db_password"
  type  = "SecureString"
  value = var.db_password
  overwrite = true
}
