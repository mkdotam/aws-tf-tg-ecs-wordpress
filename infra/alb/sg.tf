
resource "aws_security_group" "alb_sg" {
  name   = "${var.project}-${var.env}-alb-sg"
  vpc_id = var.vpc_id

  ingress {
    protocol         = "tcp"
    from_port        = var.alb_port
    to_port          = var.host_port
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}
