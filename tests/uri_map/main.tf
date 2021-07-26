terraform {
  required_version = ">= 0.12"
}

data "terraform_remote_state" "prereq" {
  backend = "local"
  config = {
    path = "prereq/terraform.tfstate"
  }
}

module "uri_map" {
  source = "../../"

  bucket_name = data.terraform_remote_state.prereq.outputs.bucket.id
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
    "https://bootstrap.pypa.io/get-pip.py"         = "python/pip/"
    "https://bootstrap.pypa.io/pip/2.6/get-pip.py" = "python/pip/2.6/"

    # salt for windows
    "http://repo.saltstack.com/windows/Salt-Minion-3000.9-Py2-AMD64-Setup.exe" = "saltstack/salt/windows/"
    "http://repo.saltstack.com/windows/Salt-Minion-3000.9-Py3-AMD64-Setup.exe" = "saltstack/salt/windows/"
  }

  prefix = "repo/"
}
