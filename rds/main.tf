module "s3_common" {
  source        = "github.com/altirllc/infra-modules.git//terraform/modules/aws/s3?ref=tf-modules"
  owner         = var.owner
  environment   = var.environment
  bucket_suffix = "common"
  tags          = local.tags
}