/*
  Ingest Bucket
*/
resource "aws_s3_bucket" "keagan_terra_test" {
  bucket = var.bucket_name_ingest
}

resource "aws_s3_bucket_notification" "object_created_notification" {
  bucket = aws_s3_bucket.keagan_terra_test.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.ingest_lambda.arn
    events = [
      "s3:ObjectCreated:*"
    ]
    filter_prefix = "vod_manager/"
    filter_suffix = ".mp4"
  }
}


/*
  CloudTrail Bucket
*/
resource "aws_s3_bucket" "vod_trail_bucket" {
  bucket = var.bucket_name_cloudtrail
}

/*
  Bucket policy to allow CloudTrail to put objects into the bucket
*/
resource "aws_s3_bucket_policy" "vod_bucket_policy_allow_cloudtrail" {
  depends_on = [
    aws_s3_bucket.vod_trail_bucket
  ]
  bucket = aws_s3_bucket.vod_trail_bucket.id

  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
            Sid: "AWSCloudTrailAclCheck",
            Effect: "Allow",
            Principal: {
              Service: "cloudtrail.amazonaws.com"
            },
            Action: "s3:GetBucketAcl",
            Resource: aws_s3_bucket.vod_trail_bucket.arn
        },
        {
            Sid: "AWSCloudTrailWrite",
            Effect: "Allow",
            Principal: {
              Service: "cloudtrail.amazonaws.com"
            },
            Action: "s3:PutObject",
            Resource: "arn:aws:s3:::${aws_s3_bucket.vod_trail_bucket.id}/prefix/AWSLogs/${data.aws_caller_identity.current_iam_user.account_id}/*",
            Condition: {
                StringEquals: {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
  })
}



resource "aws_s3_bucket_public_access_block" "prevent_bucket_becoming_public" {
  depends_on = [
    aws_s3_bucket.keagan_terra_test,
    aws_s3_bucket.vod_trail_bucket
  ]
  bucket = aws_s3_bucket.keagan_terra_test.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}