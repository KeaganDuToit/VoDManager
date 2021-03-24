/*
  The role that will be attached to all Lambdas used throughout the state machine
*/
resource "aws_iam_role" "iam_for_lambda" {
  name = var.iam_role_lambda
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

/*
  Policy that will be attached to the IAM role and grants access to S3, Transcribe, MediaConvert, DynamoDb
  All required services that will be used throughout the state machine
*/
resource "aws_iam_role_policy" "policy_for_lambda_vod" {
  depends_on = [
    aws_s3_bucket.keagan_terra_test,
    aws_iam_role.iam_for_lambda
  ]
  name = var.iam_policy_lambda
  role = aws_iam_role.iam_for_lambda.id
   policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:*",
          ]
          Effect   = "Allow"
          Resource = "${aws_s3_bucket.keagan_terra_test.arn}/*"
        },
        {
          Action = [
            "mediaconvert:*",
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
   })
}

resource "aws_iam_policy_attachment" "lambda_basic_execution" {
  depends_on = [
    aws_iam_role.iam_for_lambda
  ]
  name = "managed-policy-attachment"
  roles = [
    aws_iam_role.iam_for_lambda.name
  ]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
