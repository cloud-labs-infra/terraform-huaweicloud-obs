module "naming" {
  source = "git::https://github.com/cloud-labs-infra/terraform-naming-convention.git?ref=v1.0.0"

  environment = var.environment
  project     = var.project
}

module "obs_tst" {
  source  = "cloud-labs-infra/obs/huaweicloud"
  version = "1.1.0"

  name          = module.naming.common_name
  policy_format = "obs"

  policy = templatefile("${path.module}/templates/obs_policy.json", {
    resource = module.naming.common_name
  })
}
