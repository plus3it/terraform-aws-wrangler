output "bucket_name" {
  description = "Name of the S3 Bucket"
  value       = "${aws_s3_bucket.this.id}"
}

output "file_keys" {
  description = "List of file keys created in the S3 bucket"
  value       = ["${aws_s3_bucket_object.files.*.key}"]
}

output "file_etags" {
  description = "List of file ETags generated for each object in the bucket"
  value       = ["${aws_s3_bucket_object.files.*.etag}"]
}

output "hash_keys" {
  description = "List of hash keys created in the S3 bucket"
  value       = ["${aws_s3_bucket_object.hashes.*.key}"]
}

output "hash_etags" {
  description = "List of hash ETags generated for each object in the bucket"
  value       = ["${aws_s3_bucket_object.hashes.*.etag}"]
}

output "public_ip" {
  description = "Public IP of the salt-reposync EC2 instance"
  value       = "${module.salt_reposync.public_ip}"
}

output "private_key" {
  description = "Private key for the salt-reposync keypair"
  value       = "${module.salt_reposync.private_key}"
}
