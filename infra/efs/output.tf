output "efs_id" {
  value = aws_efs_file_system.fs.id
}

output "efs_access_point_id" {
  value = aws_efs_access_point.fs.id
}