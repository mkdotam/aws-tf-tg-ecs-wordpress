variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "region" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "alb_port" {
  type = number
}

variable "container_port" {
  type    = number
  default = 2368
}

variable "host_port" {
  type    = number
  default = 2368
}

variable "task_cpu" {
  type    = number
  default = 256
}

variable "task_memory" {
  type    = number
  default = 512
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "private_cidr_blocks" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "public_cidr_blocks" {
  type = list(string)
}

variable "efs_id" {
  type = string
}

variable "efs_arn" {
  type = string
}

variable "efs_access_point_arn" {
  type = string
}

variable "efs_access_point_id" {
  type = string
}

variable "db_secrets_arn" {
  type = string
}

variable "alb_dns_name" {
  type = string
}

variable "alb_target_group_arns" {
  type = list(string)
}

variable "alb_target_group_names" {
  type = list(string)
}

variable "alb_https_listener_arns" {
  type = list(string)
}

variable "alb_http_tcp_listener_arns" {
  type = list(string)
}

variable "alb_sg" {
  type = any
}