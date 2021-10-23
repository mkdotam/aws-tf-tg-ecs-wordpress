variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "database_subnets" {
  type = list(string)
}

variable "private_cidr_blocks" {
  type = list(string)
}

variable "public_cidr_blocks" {
  type = list(string)
}
