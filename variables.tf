variable "name" {
  description = "Specifies the name of the Object Store"
  type        = string
  nullable    = false
}

variable "name_postfix" {
  description = "Name Postfix"
  type        = string
  default     = null
}

variable "versioning" {
  description = "Whether enable versioning"
  type        = string
  default     = false
}

variable "region" {
  description = "Specifies the region in which to create the resource. If omitted, the provider-level region will be used"
  type        = string
  default     = null
}

variable "storage_class" {
  description = "Specifies the storage class of the bucket"
  type        = string
  default     = "STANDARD"
  validation {
    condition     = contains(["STANDARD", "WARM", "COLD"], var.storage_class)
    error_message = "OBS provides three storage classes: 'STANDARD', 'WARM' (Infrequent Access) and 'COLD' (Archive)."
  }
}

variable "acl" {
  description = "Specifies the ACL policy for a bucket"
  type        = string
  default     = "private"
  validation {
    condition     = contains(["private", "public-read", "public-read-write", "log-delivery-write"], var.acl)
    error_message = "The predefined common policies are as follows: 'private', 'public-read', 'public-read-write' and 'log-delivery-write'."
  }
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket, so that the bucket can be destroyed without error"
  type        = bool
  default     = false
}

variable "policy" {
  description = <<DES
  Specifies the text of the bucket policy in JSON format. For more information about obs format bucket policy,
  see the Developer Guide https://support.huaweicloud.com/intl/en-us/perms-cfg-obs/obs_40_0004.html
  DES
  type        = string
  default     = null
}

variable "policy_format" {
  description = "Specifies the policy format, the supported values are obs and s3. Defaults to obs"
  type        = string
  default     = null
}

variable "lifecycle_rules" {
  description = <<DES
  A configuration of object lifecycle management:

  * `key` - Unique identifier for lifecycle rules, the Rule Name contains a maximum of 255 characters;
  * `enabled` - Specifies lifecycle rule status;
  * `prefix`  - Object key prefix identifying one or more objects to which the rule applies. If omitted, all objects in
    the bucket will be managed by the lifecycle rule;
  * `expiration_days` - Specifies the number of days when objects that have been last updated are automatically deleted.
DES
  type = map(object({
    enabled         = optional(bool, true)
    prefix          = optional(string, null)
    expiration_days = number
  }))
  default = {}
}

variable "cors_rules" {
  description = <<DES
  A configuration of object CORS rules:

  * `allowed_origins` - Requests from this origin can access the bucket;
  * `allowed_methods` - Specifies the acceptable operation type of buckets and objects;
  * `max_age_seconds` - Specifies the duration that your browser can cache CORS responses, expressed in seconds;
DES
  type = list(object({
    allowed_origins = list(string)
    allowed_methods = list(string)
    max_age_seconds = optional(number, 100)
  }))
  default = []
  validation {
    condition = alltrue(flatten([
      for rule in var.cors_rules : [
        for method in rule.allowed_methods :
        contains(["GET", "PUT", "POST", "DELETE", "HEAD"], method)
      ]
    ]))
    error_message = "Each method in allowed_methods should be one of: 'GET', 'PUT', 'POST', 'DELETE', 'HEAD'."
  }
}

variable "tags" {
  description = "Specifies the key/value pairs to associate with the OBS"
  type        = map(string)
  default     = {}
}
