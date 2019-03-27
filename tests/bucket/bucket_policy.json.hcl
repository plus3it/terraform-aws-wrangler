{
    "Statement": [
        {
            "Action": "s3:*",
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            },
            "Effect": "Deny",
            "Principal": "*",
            "Resource": "arn:${partition}:s3:::${bucket_name}/*",
            "Sid": "DenyInsecureTransport"
        },
        {
            "Action": "s3:GetObject",
            "Condition": {
                "IpAddress": {
                    "aws:SourceIp": ${jsonencode(compact(split(",", replace("${list_o_things}", "\n", ""))))}
                }
            },
            "Effect": "Allow",
            "Principal": "*",
            "Resource": "arn:${partition}:s3:::${bucket_name}/*",
            "Sid": "AllowConditionalRead"
        }
    ],
    "Version": "2012-10-17"
}
