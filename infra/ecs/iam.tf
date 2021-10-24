data "aws_iam_policy_document" "ecs_task_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task" {
  name               = "${var.project}-${var.env}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
}

resource "aws_iam_role_policy" "ecs_task" {
  name   = "${var.project}-${var.env}-ecs-task-role-policy"
  role   = aws_iam_role.ecs_task.name
  policy = data.aws_iam_policy_document.ecs_task.json
}

data "aws_iam_policy_document" "ecs_task" {
  statement {
    actions = [
      "efs:*",
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListAllMyBuckets",
      "s3:ListBucket",
      "s3:HeadBucket",
    ]

    resources = [
      "*"
    ]
    effect = "Allow"
  }
}

resource "aws_iam_role" "ecs_task_exec" {
  name               = "${var.project}-${var.env}-ecs-task-exec-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
}

resource "aws_iam_role_policy" "ecs_task_exec" {
  name   = "${var.project}-${var.env}-ecs-task-exec-role-policy"
  role   = aws_iam_role.ecs_task_exec.name
  policy = data.aws_iam_policy_document.ecs_task_exec.json
}

data "aws_iam_policy_document" "ecs_task_exec" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]

    resources = [
      "*",
    ]

    effect = "Allow"
  }
}


resource "aws_iam_policy" "efs" {
  name        = "${var.project}-task-policy-efs"
  description = "Policy that allows working with EFS"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AccessToEFS",
            "Effect": "Allow",
            "Action": [
                "elasticfilesystem:ClientMount",
                "elasticfilesystem:ClientWrite"
            ],
            "Resource": "${var.efs_arn}",
            "Condition": {
                "StringEquals": {
                    "elasticfilesystem:AccessPointArn": "${var.efs_access_point_arn}"
                }
            }
        }
    ]
}
EOF
}

resource "aws_iam_policy" "secrets" {
  name        = "${var.project}-task-policy-secrets"
  description = "Policy that allows access to the secrets"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AccessSecrets",
            "Effect": "Allow",
            "Action": "secretsmanager:GetSecretValue",
            "Resource": [
                     "${var.db_secrets_arn}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-exec-role-policy-attachment-for-secrets" {
  role       = aws_iam_role.ecs_task_exec.name
  policy_arn = aws_iam_policy.secrets.arn
}

resource "aws_iam_role_policy_attachment" "ecs-task-exec-role-policy-attachment-for-efs" {
  role       = aws_iam_role.ecs_task_exec.name
  policy_arn = aws_iam_policy.efs.arn
}
