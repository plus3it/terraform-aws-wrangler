# terraform-aws-wrangler

Terraform module to collect files from various sources and manage them in an S3
bucket.

## Usage

This module requires that several terraform *.tf files be rendered prior to
usage. This is a result of terraform resources being tracked by their `count`
index. When the order of the `count` input changes, so does the index value in
the terraform state. This leads to terraform wanting to destroy and re-create
every resource. Follow [Terraform Issue 17179][terraform-issue-17179] for more
information on the problem (see linked issues) and the proposed fix.

In the meantime, to workaround this problem, we render the necessary .tf files
using Jinja2. This creates distinct resources for every item in the inputs,
rather than relying on `count` to create multiple resources.

Before rendering the .tf files, first install the requirements:

```
pip install requirements.txt
```

Then render the files:

```
python render.py -var-file <var-file1> -var-file <var-file2> ... -var-file <var-fileN>
```

Once rendered, run terraform as usual, passing the same var-file(s):

```
terraform init
terraform apply -var-file <var-file1> -var-file <var-file2> ... -var-file <var-fileN>
```

We recommend using Terragrunt and [Terragrunt hooks][terragrunt-hooks], in
particular, to automate these steps.


[terraform-issue-17179]: https://github.com/hashicorp/terraform/issues/17179

## Use Cases

This module supports a few use cases, managed by specifying different
variables.

1.  Creates an S3 bucket and applies a bucket policy.
2.  Retrieves files from source URIs and stores them in an S3 bucket.
3.  Creates a Salt yum mirror in an S3 bucket (salt-reposync).
4.  Copies files from one S3 bucket to another.

### Create an S3 bucket

To create an S3 bucket, use the variables:

-   `bucket_name` - Name of the S3 bucket.
-   `bucket_policy` - Filepath to the JSON bucket policy. This file is
    templated using the Terraform [template provider][template-provider].
    Variables passed through the templater include:
    -   `bucket_name`
    -   `prefix`
-   `create_bucket` - Set to `"true"` to create the bucket.

When using this module for other use cases, if `create_bucket` is `"false"`,
then the bucket specified by `bucket_name` must already exist. You _can_ also
combine use cases, creating the bucket in the same terraform configuration.

[template-provider]: https://www.terraform.io/docs/providers/template/d/file.html

### Retrieve files and store them in an S3 bucket

These variables are used to retrieve files and store them in an S3 bucket:

-   `uri_map` - Map of `URI = S3 Path`. Each `URI` will be retrieved and the
    file will be saved to `S3 Path`. The filename is preserved. If the map is
    empty (the default), no files are retrieved. Here is an example of the
    structure:

    ```hcl
    uri_map = {
      # salt for windows
      "http://repo.saltstack.com/windows/Salt-Minion-2016.11.6-AMD64-Setup.exe" = "saltstack/salt/windows/"

      # pbis open
      "https://repo.pbis.beyondtrust.com/yum/pbiso/x86_64/Packages/pbis-open-8.6.0-427.x86_64.rpm"         = "beyond-trust/pbis-open/"
      "https://repo.pbis.beyondtrust.com/yum/pbiso/x86_64/Packages/pbis-open-upgrade-8.6.0-427.x86_64.rpm" = "beyond-trust/pbis-open/"
      "https://repo.pbis.beyondtrust.com/yum/pbiso/x86_64/Packages/pbis-open-legacy-8.6.0-427.x86_64.rpm"  = "beyond-trust/pbis-open/"
    }
    ```

-   `bucket_name` - Name of the S3 bucket where files will be stored.
-   `prefix` - S3 prefix prepended to all S3 key paths when the files are put
    in the bucket.

### Create yum repo mirror for a specific Salt version

To create a yum mirror for Salt, use these variables:

-   `salt_version` - Version of salt to mirror. If empty (the default), then no
    Salt yum repo mirror will be created.
-   `salt_repo_prefix` - S3 path prepended to all files in the Salt yum repo
    mirror.
-   `bucket_name` - S3 bucket where the salt yum mirror will be created.

This feature uses the [`salt-reposync`][salt-reposync] module, which launches
an EC2 instance that mirrors the repo via rsync. The EC2 resources created by
the `salt-reposync` module will remain behind (incurring charges) unless you
destroy them. To destroy them, run:

-   `terraform destroy -target module.salt_reposync`

It is safe to destroy the module...the mirrored yum repo will remain. It is
also safe to re-create the mirror by specifying a salt version that has already
been mirrored to the same bucket/prefix. If you use terragrunt, you _may_ want
to use its "after" [hook][terragrunt-hooks] to automate the destroy action.

[salt-reposync]: https://github.com/plus3it/salt-reposync
[terragrunt-hooks]: https://github.com/gruntwork-io/terragrunt#before-and-after-hooks

### Copy files from one bucket to another

Copying files from one bucket to another uses the following variables:

-   `s3_objects_map` - A map of S3 bucket names to a list of key
    prefixes in that bucket. The objects are filtered by the prefixes... All
    objects matching the prefixes will be copied to the destination bucket. To
    copy _all_ objects, specify an empty list (meaning, no prefix filtering).
    -   Example 1 - Copy all objects from a bucket, `foo`:

        ```hcl
        s3_objects_map = {
          "foo" = []
        }
        ```

    -   Example 2 - Copy objects matching the prefixes, `bar/` and `baz/`:

        ```hcl
        s3_objects_map = {
          "foo" = [
            "bar/",
            "baz/",
          ]
        }
        ```

    -   Example 3 - Copy objects from multiple buckets, `foo` and `bar`:

        ```hcl
        copy_bucket_objects_map = {
          "foo" = []
          "bar" = []
        }
        ```

-   `bucket_name` - Destination bucket where files will be copied to.
-   `prefix` - S3 path prepended to all files copied to the destination bucket.
