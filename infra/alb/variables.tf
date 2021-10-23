variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "alb_port" {
  type = number
}

variable "host_port" {
  type = number
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}
