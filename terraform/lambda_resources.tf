/*
  The Lambda
*/
resource "aws_lambda_function" "ingest_lambda" {
  depends_on = [
    data.archive_file.zip_lambda
  ]
  function_name = var.lambda_function_name_ingestor
  handler = "audio_converter_lambda.lambda_audio_converter"
  role = aws_iam_role.iam_for_lambda.arn
  runtime = "python3.7"
  environment {
    variables = {
      "MEDIACONVERT_AUDIO_TEMPLATE_NAME" : "audio_for_transcribe",
      "MEDIACONVERT_ROLE_ARN" : "arn:aws:iam::217690689548:role/service-role/MediaConvert_Default_Role",
      "MEDIACONVERT_ENDPOINT" : "https://r1eeew44a.mediaconvert.eu-west-1.amazonaws.com"
    }
  }
  filename = data.archive_file.zip_lambda.output_path
  source_code_hash = filebase64sha256(data.archive_file.zip_lambda.output_path)
}


resource "aws_lambda_permission" "s3_permissions_invoke_lambda" {
  statement_id = "AllowS3Invoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ingest_lambda.function_name
  principal = "s3.amazonaws.com"
  source_arn = aws_s3_bucket.keagan_terra_test.arn
  source_account = data.aws_caller_identity.current_iam_user.account_id
}