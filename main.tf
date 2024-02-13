resource "aws_s3_bucket" "cappyzawa_lambda_packages" {
  bucket              = "cappyzawa-lambda-packages"
  object_lock_enabled = true

  tags = {
    Developer     = "cappyzawa"
    WillBeDeleted = "yes"
  }
}

module "lambda_function_hello" {
  source                             = "terraform-aws-modules/lambda/aws"
  version                            = "7.2.1"
  source_path                        = "scripts/hello.py"
  function_name                      = "cappyzawa-hello"
  description                        = "A sample function for cappyzawa"
  handler                            = "hello.lambda_handler"
  runtime                            = "python3.9"
  store_on_s3                        = true
  s3_bucket                          = aws_s3_bucket.cappyzawa_lambda_packages.id
  artifacts_dir                      = "yokidir"
  attach_cloudwatch_logs_policy      = false
  attach_create_log_group_permission = false
  trigger_on_package_timestamp       = false
  cloudwatch_logs_retention_in_days  = 180
  create_sam_metadata                = true
  timeout                            = 10
}
