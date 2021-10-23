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

variable "cidr_block" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "database_subnets" {
  type = list(string)
}