data "aws_iam_account_alias" "current" {}

provider "aws" {
  region = var.region
}

module "web" {
  source                      = "./modules/web"
  environment                 = var.environment
  cognito_user_pool_id        = module.authentication.cognito_user_pool_id
  cognito_user_pool_client_id = module.authentication.cognito_user_pool_client_id
  api_invoke_Url              = module.api.api_invoke_Url
  region                      = var.region
  account_alias               = data.aws_iam_account_alias.current.account_alias
}

module "authentication" {
  source = "./modules/authentication"
}

module "api" {
  source                = "./modules/api"
  region                = var.region
  cognito_user_pool_arn = module.authentication.cognito_user_pool_arn
  lambda_arn            = module.compute.wild-rydes-lambda-arn
}

module "storage" {
  source = "./modules/storage"
}

module "compute" {
  source          = "./modules/compute"
  environment     = var.environment
  dynamo_arn      = module.storage.dynamodb_table_arn
  api_gateway_arn = module.api.wild-rydes-api-gateway-arn
}

