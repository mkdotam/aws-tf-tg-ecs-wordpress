variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}
