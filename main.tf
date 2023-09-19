locals {
  name = var.name_postfix == null ? var.name : format("%s-%s", var.name, var.name_postfix)
}

resource "huaweicloud_obs_bucket" "main" {
  bucket        = local.name
  region        = var.region
  storage_class = var.storage_class
  acl           = var.acl
  versioning    = var.versioning
  force_destroy = var.force_destroy
  policy        = var.policy
  policy_format = var.policy_format

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      name    = lifecycle_rule.key
      enabled = lifecycle_rule.value.enabled
      prefix  = lifecycle_rule.value.prefix
      expiration {
        days = lifecycle_rule.value.expiration_days
      }
    }
  }

  dynamic "cors_rule" {
    for_each = var.cors_rules
    content {
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }

  tags = var.tags
}
