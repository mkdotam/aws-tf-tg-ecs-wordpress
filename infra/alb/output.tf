output "alb_dns_name" {
  value = module.alb.lb_dns_name
}

output "alb_target_group_arns" {
  value = module.alb.target_group_arns
}

output "alb_target_group_names" {
  value = module.alb.target_group_names
}

output "alb_https_listener_arns" {
  value = module.alb.https_listener_arns
}

output "alb_http_tcp_listener_arns" {
  value = module.alb.http_tcp_listener_arns
}

output "alb_sg" {
  value = aws_security_group.alb_sg
}