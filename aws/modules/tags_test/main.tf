module "tags" {
  source        = "../tags"
  account       = var.account
  aws_region    = var.aws_region
  cloudprovider = var.cloudprovider
  creator       = var.creator
  environment   = var.environment
}