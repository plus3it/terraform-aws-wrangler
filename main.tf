module "file_cache" {
  source = "git::https://github.com/plus3it/terraform-external-file-cache.git?ref=2.0.0"

  python_cmd = var.python_cmd
  uris       = keys(var.uri_map)
}

resource "aws_s3_bucket_object" "file" {
  for_each = var.uri_map

  bucket = var.bucket_name
  key    = local.uri_objects[each.key].key
  source = module.file_cache.filepaths[each.key]
  etag   = filemd5(module.file_cache.filepaths[each.key])
}

resource "aws_s3_bucket_object" "hash" {
  for_each = var.uri_map

  bucket       = var.bucket_name
  key          = "${local.uri_objects[each.key].key}.SHA512"
  content      = local.uri_objects[each.key].hash_content
  content_type = "application/octet-stream"
  etag         = md5(local.uri_objects[each.key].hash_content)
}

locals {
  uri_objects = {
    for uri, filepath in module.file_cache.filepaths : uri => {
      key          = "${var.prefix}${var.uri_map[uri]}${basename(filepath)}"
      hash_content = "${filesha512(filepath)} ${basename(filepath)}"
    }
  }
}
