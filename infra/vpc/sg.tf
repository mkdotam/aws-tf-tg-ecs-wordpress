
resource "aws_security_group" "vpc_endpoint_sg" {
  name   = "${var.project}-${var.env}-vpc-endpoint-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}
