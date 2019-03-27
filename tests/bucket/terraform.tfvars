terragrunt = {
    terraform = {
        source = "../../"

        after_hook "requirements" {
            commands = ["init-from-module"]
            execute  = ["pipenv", "install", "-r", "requirements.txt"]
        }

        after_hook "render" {
            commands = ["init-from-module"]
            execute  = ["pipenv", "run", "python", "render.py", "-var-file", "${get_tfvars_dir()}/terraform.tfvars"]
        }

        extra_arguments "vars" {
            commands = ["${get_terraform_commands_that_need_vars()}"]

            arguments = [
                "-var-file",
                "${get_tfvars_dir()}/terraform.tfvars"
            ]
        }
    }
}

python_cmd    = ["pipenv", "run", "python"]

create_bucket = true

bucket_name   = "wrangler-test-bucket"

bucket_policy = "bucket_policy.json.hcl"

bucket_policy_vars = {
    list_o_things = <<-EOF
        10.0.0.0/16,
        10.1.0.0/16,
        10.2.0.0/16,
        EOF
}
