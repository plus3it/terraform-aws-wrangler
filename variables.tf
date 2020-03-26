variable "bucket_name" {
  type        = "string"
  description = "Name of the S3 bucket where file artifacts are to be stored"
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

variable "s3_objects_map" {
  type        = "map"
  description = "Map of bucket names to a list of prefixes -- objects in each bucket matching each prefix will be retrieved and copied to \"bucket_name\""
  default     = {}
}
