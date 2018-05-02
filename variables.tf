variable "bucket_name" {
  type        = "string"
  description = "Name of the S3 bucket where file artifacts are to be stored"
}

variable "bucket_policy" {
  type        = "string"
  description = "File path to the bucket policy template"
  default     = "templates/bucket_policy.json"
}

variable "create_bucket" {
  type        = "string"
  description = "Toggle that determines whether to create the bucket -- if false, bucket must already exist"
  default     = "false"
}

variable "uri_map" {
  type        = "map"
  description = "Map of URIs to retrieve and the S3 key path at which to store the file"
  default     = {}
}

variable "prefix" {
  type        = "string"
  description = "S3 key prefix to prepend to each object"
  default     = ""
}

variable "salt_repo_prefix" {
  type        = "string"
  description = "S3 key prefix for the Salt yum repo"
  default     = ""
}

variable "salt_version" {
  type        = "string"
  description = "Salt version to retrieve and push to the S3 bucket"
  default     = ""
}

variable "s3_objects_map" {
  type        = "map"
  description = "Map of bucket names to a list of prefixes -- objects in each bucket matching each prefix will be retrieved and copied to \"bucket_name\""
  default     = {}
}
