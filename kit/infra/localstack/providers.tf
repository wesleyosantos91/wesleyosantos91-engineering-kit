provider "aws" {
  region                      = var.aws_region
  access_key                  = "test"
  secret_key                  = "test"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway     = local.localstack_endpoint
    cloudformation = local.localstack_endpoint
    cloudwatch     = local.localstack_endpoint
    dynamodb       = local.localstack_endpoint
    events         = local.localstack_endpoint
    iam            = local.localstack_endpoint
    lambda         = local.localstack_endpoint
    logs           = local.localstack_endpoint
    s3             = local.localstack_endpoint
    sns            = local.localstack_endpoint
    sqs            = local.localstack_endpoint
    sts            = local.localstack_endpoint
  }
}
