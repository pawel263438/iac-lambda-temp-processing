provider "aws" {
  region = "us-east-1"  
}


data "aws_iam_role" "existing_lambda_role" {
  name = "LabRole"  # <- tu podaj nazwę roli, którą masz w AWS
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
