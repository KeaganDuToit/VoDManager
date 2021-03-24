// This is where all global settings will be
provider "aws" {
  profile = "default"
  region = "eu-west-1"
}

/*
  S3 Resource names
*/
variable "bucket_name_ingest" {
  type = string
  default = "keagan-terra-test"
}

variable "bucket_name_cloudtrail" {
  type = string
  default = "vod-cloudtrail-store"
}
/******************************************************/


/*
  Lambda resource names
*/
variable "iam_role_lambda" {
  type = string
  default = "lambdaVodIam"
}

variable "iam_policy_lambda" {
  type = string
  default = "Lambda-Vod"
}

variable "lambda_function_name_ingestor" {
  type = string
  default = "lambda-testing"
}
/******************************************************/


/*
  Local resource path and names
*/
variable "path_to_lambdas" {
  type = string
  default = "C:/Users/dutoi/PycharmProjects/VoDManager/lambdas/"
}

variable "local_lambda_ingest_name" {
  type = string
  default = "audio_converter_lambda"
}
/******************************************************/


data "archive_file" "zip_lambda" {
  type        = "zip"
  source_file = "${var.path_to_lambdas}${var.local_lambda_ingest_name}.py"
  output_path = "${var.path_to_lambdas}${var.local_lambda_ingest_name}.zip"
}
data "aws_caller_identity" "current_iam_user" {}