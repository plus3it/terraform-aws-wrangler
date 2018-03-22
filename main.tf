locals {
  uris     = "${keys(var.uri_map)}"
  s3_paths = "${values(var.uri_map)}"
}

data "template_file" "bucket_policy" {
  template = "${file(var.bucket_policy)}"

  vars {
    bucket_name = "${var.bucket_name}"
  }
}

resource "aws_s3_bucket" "this" {
  bucket = "${var.bucket_name}"
  policy = "${data.template_file.bucket_policy.rendered}"
}

module "file_cache" {
  source = "git::https://github.com/plus3it/terraform-external-file-cache?ref=1.0.1"

  uris = "${local.uris}"
}

module "salt_reposync" {
  source = "git::https://github.com/plus3it/salt-reposync?ref=1.0.0"

  # Remove trailing slash from salt repo prefix
  repo_base    = "https://s3.amazonaws.com/${aws_s3_bucket.this.id}/${var.prefix}${replace(var.salt_repo_prefix, "/[/]$/", "")}"
  salt_version = "${var.salt_version}"
}

data "null_data_source" "files" {
  count = "${length(local.uris)}"

  inputs {
    filepath = "${element(module.file_cache.filepaths, count.index)}"
    filename = "${replace(basename(element(module.file_cache.filepaths, count.index)), "%20", " ")}"
    hash_content = "${sha512(element(module.file_cache.filepaths, count.index))} ${replace(basename(element(module.file_cache.filepaths, count.index)), "%20", " ")}"
  }
}

resource "aws_s3_bucket_object" "files" {
  count = "${length(data.null_data_source.files.*.outputs.filepath)}"

  bucket = "${aws_s3_bucket.this.id}"
  key    = "${var.prefix}${element(local.s3_paths, count.index)}${element(data.null_data_source.files.*.outputs.filename, count.index)}"
  source = "${element(data.null_data_source.files.*.outputs.filepath, count.index)}"
  etag   = "${md5(file(element(data.null_data_source.files.*.outputs.filepath, count.index)))}"
}

resource "aws_s3_bucket_object" "hashes" {
  count = "${length(data.null_data_source.files.*.outputs.filepath)}"

  bucket       = "${aws_s3_bucket.this.id}"
  key          = "${var.prefix}${element(local.s3_paths, count.index)}${element(data.null_data_source.files.*.outputs.filename, count.index)}.SHA512"
  content      = "${element(data.null_data_source.files.*.outputs.hash_content, count.index)}"
  content_type = "application/octet-stream"
  etag         = "${md5("${element(data.null_data_source.files.*.outputs.hash_content, count.index)}")}"
}
