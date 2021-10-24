#resource "aws_efs_file_system_policy" "policy" {
#  file_system_id = aws_efs_file_system.fs.id
#
#  bypass_policy_lockout_safety_check = true
#
#  policy = <<POLICY
#{
#    "Version": "2012-10-17",
#    "Id": "ExamplePolicy01",
#    "Statement": [
#        {
#            "Effect": "Allow",
#            "Principal": {
#                "AWS": "*"
#            },
#            "Resource": "${aws_efs_file_system.fs.arn}",
#            "Action": [
#                "elasticfilesystem:ClientMount",
#                "elasticfilesystem:ClientWrite"
#            ],
#            "Condition": {
#                "StringEquals": {
#                  "elasticfilesystem:AccessPointArn": "${aws_efs_access_point.fs.file_system_id}"
#                }
#            }
#        }
#    ]
#}
#POLICY
#}
#

