output "files" {
  description = "Map of file keys => source_hash"
  value       = { for object in aws_s3_object.file : object.id => object.source_hash }
}

output "hashes" {
  description = "Map of hash keys => source_hash"
  value       = { for object in aws_s3_object.hash : object.id => object.source_hash }
}
