module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.5.0"

  name = "${var.project}-${var.env}-alb"

  load_balancer_type = "application"

  vpc_id          = var.vpc_id
  subnets         = var.public_subnets
  security_groups = [aws_security_group.alb_sg.id]

  target_groups = [
    {
      name_prefix      = "${substr((var.project), 0, 5)}-"
      backend_protocol = "HTTP"
      backend_port     = var.host_port
      target_type      = "ip"
      stickiness = {
        type    = "lb_cookie"
        enabled = true
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = var.alb_port
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  #  access_logs = {
  #    bucket   = aws_s3_bucket.alb_log_bucket.id
  #    interval = 60
  #  }
  #
  #  depends_on = [
  #    aws_s3_bucket.alb_log_bucket
  #  ]

  tags = var.tags
}

#resource "aws_s3_bucket" "alb_log_bucket" {
#  bucket = "${var.project}-${var.env}-alb-logs-bucket"
#  acl    = "private"
#
#  lifecycle_rule {
#    id      = "log"
#    enabled = true
#
#    prefix = "/"
#
#    tags = {
#      rule      = "log"
#      autoclean = "true"
#    }
#
#    transition {
#      days          = 30
#      storage_class = "STANDARD_IA"
#    }
#
#    transition {
#      days          = 60
#      storage_class = "GLACIER"
#    }
#
#    expiration {
#      days = 90
#    }
#  }
#
#  tags = var.tags
#}
