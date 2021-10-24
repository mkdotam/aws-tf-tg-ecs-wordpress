resource "aws_efs_file_system" "fs" {
  creation_token   = "${var.project}-${var.env}-efs"
  encrypted        = true
  performance_mode = "generalPurpose"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = merge(var.tags,
    { "Name" : "${var.project}-${var.env}-efs" }
  )
}

resource "aws_efs_access_point" "fs" {
  file_system_id = aws_efs_file_system.fs.id

  root_directory {
    path = "/"

    creation_info {
      permissions = "0755"
      owner_gid   = 1001
      owner_uid   = 1001
    }
  }
  tags = merge(var.tags,
    { "Name" : "${var.project}-${var.env}-access-point" }
  )
}

resource "aws_efs_mount_target" "fs" {
  file_system_id  = aws_efs_file_system.fs.id
  security_groups = [aws_security_group.efs_sg.id]
  count           = length(var.private_subnets)
  subnet_id       = var.private_subnets[count.index]
}
