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
  # The predefined common policies are as follows: "private", "public-read", "public-read-write" and "log-delivery-write".
  type    = string
  default = "private"
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket, so that the bucket can be destroyed without error"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Specifies the key/value pairs to associate with the VPC"
  type        = map(string)
  default     = {}
}
