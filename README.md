[![pullreminders](https://pullreminders.com/badge.svg)](https://pullreminders.com?ref=badge)

# terraform-aws-wrangler

Terraform module to collect files from various sources and manage them in an S3
bucket. In order to support arbitrary file-types, this module uses [`terraform-external-file-cache`](https://registry.terraform.io/modules/plus3it/file-cache/external)
to create a local cache of the files. The files are then managed in the S3
bucket using the terraform resource `aws_s3_bucket_object`. A sha512 hash of
every file is also published to the bucket.

## Use Cases

This module supports a couple use cases:

1.  Retrieve files from source URIs and store them in an S3 bucket.
2.  Copy files from one S3 bucket to another.

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

### Copy files from one bucket to another

This is accomplished by getting a list of the s3 objects in the source bucket,
and constructing the `uri_map`. This list can be provided using the data source
`aws_s3_bucket_objects`, but when doing so it is recommended to generate that
list in a separate state and output the value. This is because the output of a
data source or resource **cannot** be used in the `for_each` statement of a
resource (without encountering chicken/egg problems).

See the [`s3_sync` test](tests/s3_sync) for an example.

<!-- BEGIN TFDOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket\_name | Name of the S3 bucket where file artifacts are to be stored | `string` | n/a | yes |
| prefix | S3 key prefix to prepend to each object | `string` | `""` | no |
| python\_cmd | Command to use with the filecache module when executing python external resources | `list` | <pre>[<br>  "python"<br>]</pre> | no |
| uri\_map | Map of URIs to retrieve and the S3 key path at which to store the file | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| files | Map of file keys => etags |
| hashes | Map of hash keys => etags |

<!-- END TFDOCS -->
