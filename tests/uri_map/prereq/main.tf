provider aws {
  region = "us-east-1"
}

resource "aws_s3_bucket" "this" {
  bucket_prefix = "terraform-aws-wrangler-"
}

output "bucket" {
  value = aws_s3_bucket.this
}
