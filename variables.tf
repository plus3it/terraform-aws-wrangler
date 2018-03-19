variable "bucket_name" {
  type        = "string"
  description = "Name of the S3 bucket where file artifacts are to be stored"
}

variable "bucket_policy" {
  type        = "string"
  description = "File path to the bucket policy template"
  default     = "templates/bucket_policy.json"
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
