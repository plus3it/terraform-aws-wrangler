variable "bucket_name" {
  type        = "string"
  description = "Name of the S3 bucket where file artifacts are to be stored"
}

variable "bucket_policy" {
  type        = "string"
  description = "File path to the bucket policy template"
  default     = ""
}

variable "bucket_policy_vars" {
  type        = "map"
  description = "Map of variables to make available to the bucket policy template"
  default     = {}
}

variable "create_bucket" {
  type        = "string"
  description = "Toggle that determines whether to create the bucket -- if false, bucket must already exist"
  default     = "false"
}

variable "force_destroy" {
  type        = "string"
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
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

variable "python_cmd" {
  type        = "list"
  description = "Command to use when executing python external resources"
  default     = ["python"]
}

variable "salt_repo_prefix" {
  type        = "string"
  description = "S3 key prefix for the Salt yum repo"
  default     = ""
}

variable "salt_yum_prefix" {
  type        = "string"
  description = "S3 key prefix for the Salt yum repo"
  default     = ""
}

variable "salt_version" {
  type        = "string"
  description = "Default Salt version to retrieve and push to the S3 bucket"
  default     = ""
}

variable "extra_salt_versions" {
  type        = "list"
  description = "List of additional Salt versions to retrieve and push to the S3 bucket"
  default     = []
}

variable "s3_objects_map" {
  type        = "map"
  description = "Map of bucket names to a list of prefixes -- objects in each bucket matching each prefix will be retrieved and copied to \"bucket_name\""
  default     = {}
}
