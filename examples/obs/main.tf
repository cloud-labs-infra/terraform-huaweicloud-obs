provider "huaweicloud" {
  region = "ap-southeast-3"
}

module "obs" {
  source  = "cloud-labs-infra/obs/huaweicloud"
  version = "1.0.0"

  name         = "dev01"
  name_postfix = "main"
  tags = {
    "env" : "dev01"
  }
}
