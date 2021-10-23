generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "3.59.0"
    }
  }
  required_version = ">=1.0.7"
}
EOF
}

locals {
  region  = "us-east-1"
  project = "wp-blog"
  env     = "dev"
}

remote_state {
  backend = "s3"
  config = {
    bucket  = "mk-terraform-state-bucket"
    key     = "${local.project}/${path_relative_to_include()}/terraform.tfstate"
    region  = local.region
    encrypt = true
  }
}

inputs = {
  # account
  region  = local.region
  project = local.project
  env     = local.env

  # vpc
  cidr_block       = "10.0.0.0/16"
  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets  = ["10.0.11.0/24", "10.0.12.0/24"]
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24"]

  alb_port       = 80
  host_port      = 80
  container_port = 80

  # ecs
  task_cpu    = 512
  task_memory = 1024

  # tags
  tags = {
    Project     = local.project
    Environment = local.env
  }

}
