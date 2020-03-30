terraform {
  required_version = ">= 0.12"
}

resource "aws_s3_bucket" "this" {
  bucket_prefix = "terraform-aws-wrangler-"
}

module "uri_map" {
  source = "../../"

  bucket_name = aws_s3_bucket.this.id
  prefix      = local.prefix
  uri_map     = local.uri_map
}

output "uri_map" {
  value = module.uri_map
}

locals {
  uri_map = {
    # python for windows
    "https://www.python.org/ftp/python/3.6.8/python-3.6.8-amd64.exe" = "python/python/"

    # get-pip
    "https://bootstrap.pypa.io/get-pip.py"     = "python/pip/"
    "https://bootstrap.pypa.io/2.6/get-pip.py" = "python/pip/2.6/"

    # salt for windows
    "http://repo.saltstack.com/windows/Salt-Minion-3000-Py2-AMD64-Setup.exe" = "saltstack/salt/windows/"
    "http://repo.saltstack.com/windows/Salt-Minion-3000-Py3-AMD64-Setup.exe" = "saltstack/salt/windows/"
  }

  prefix = "repo/"
}
