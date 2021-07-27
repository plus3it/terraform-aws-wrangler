variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket where file artifacts are to be stored"
}

variable "create_hashes" {
  type        = bool
  description = "Create and host sha512 hashes of each file in the `uri_map`"
  default     = true
}

variable "uri_map" {
  type        = map(string)
  description = "Map of URIs to retrieve and the S3 key path at which to store the file"
  default     = {}
}

variable "prefix" {
  type        = string
  description = "S3 key prefix to prepend to each object"
  default     = ""
}

variable "python_cmd" {
  type        = list(any)
  description = "Command to use with the filecache module when executing python external resources"
  default     = ["python"]
}

variable "s3_endpoint_url" {
  type        = string
  description = "S3 API endpoint for non-AWS hosts; format: https://hostname:port"
  default     = null
}
