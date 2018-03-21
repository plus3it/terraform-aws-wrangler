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

resource "aws_s3_bucket_object" "files" {
  count = "${length(local.uris)}"

  bucket = "${aws_s3_bucket.this.id}"
  key    = "${var.prefix}${element(local.s3_paths, count.index)}${basename(element(module.file_cache.filepaths, count.index))}"
  source = "${element(module.file_cache.filepaths, count.index)}"
  etag   = "${md5(file(element(module.file_cache.filepaths, count.index)))}"
}

data "template_file" "hashes" {
  count = "${length(local.uris)}"

  template = "${sha512(element(module.file_cache.filepaths, count.index))} ${basename(element(module.file_cache.filepaths, count.index))}"
}

resource "aws_s3_bucket_object" "hashes" {
  count = "${length(local.uris)}"

  bucket       = "${aws_s3_bucket.this.id}"
  key          = "${var.prefix}${element(local.s3_paths, count.index)}${basename(element(module.file_cache.filepaths, count.index))}.SHA512"
  content      = "${element(data.template_file.hashes.*.rendered, count.index)}"
  content_type = "application/octet-stream"
  etag         = "${md5("${element(data.template_file.hashes.*.rendered, count.index)}")}"
}
