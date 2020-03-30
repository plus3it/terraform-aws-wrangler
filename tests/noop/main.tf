module "noop" {
  source = "../../"

  bucket_name = "foo"
  uri_map     = {}
}

output "noop" {
  value = module.noop
}
