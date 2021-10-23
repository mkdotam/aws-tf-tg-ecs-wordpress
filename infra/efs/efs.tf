resource "aws_efs_file_system" "fs" {
  creation_token   = "${var.project}-${var.env}-efs"
  encrypted        = true
  performance_mode = "generalPurpose"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = var.tags
}

resource "aws_efs_access_point" "fs" {
  file_system_id = aws_efs_file_system.fs.id

  tags = var.tags
}

resource "aws_efs_mount_target" "fs" {
  file_system_id  = aws_efs_file_system.fs.id
  security_groups = [aws_security_group.efs_sg.id]
  count           = length(var.private_subnets)
  subnet_id       = var.private_subnets[count.index]
}
