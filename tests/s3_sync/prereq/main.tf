provider aws {
  region = "us-east-1"
}

resource "random_uuid" "this" {
  count = local.object_count
}

resource "aws_s3_bucket" "source" {
  bucket_prefix = "terraform-aws-wrangler-"
}

resource "aws_s3_bucket" "target" {
  bucket_prefix = "terraform-aws-wrangler-"
}

resource "aws_s3_bucket_object" "this" {
  count = local.object_count

  bucket  = aws_s3_bucket.source.id
  key     = random_uuid.this[count.index].result
  content = random_uuid.this[count.index].result
}

resource "aws_s3_bucket_object" "foo" {
  count = local.object_count

  bucket  = aws_s3_bucket.source.id
  key     = "foo/${random_uuid.this[count.index].result}"
  content = random_uuid.this[count.index].result
}
resource "aws_s3_bucket_object" "foobar" {
  count = local.object_count

  bucket  = aws_s3_bucket.source.id
  key     = "foo/bar/${random_uuid.this[count.index].result}"
  content = random_uuid.this[count.index].result
}

data "aws_s3_bucket_objects" "this" {
  bucket = aws_s3_bucket.source.id

  depends_on = [
      aws_s3_bucket_object.this,
      aws_s3_bucket_object.foo,
      aws_s3_bucket_object.foobar,
  ]
}

output "bucket_source" {
  value = aws_s3_bucket.source
}

output "bucket_target" {
  value = aws_s3_bucket.target
}

output "s3_objects" {
  value = data.aws_s3_bucket_objects.this
}

locals {
  object_count = 10
}
