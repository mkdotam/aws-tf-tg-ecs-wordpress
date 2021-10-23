include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id              = "mock"
    private_subnets     = ["mock"]
    private_cidr_blocks = ["0.0.0.0/32"]
    public_subnets      = ["mock"]
    public_cidr_blocks  = ["0.0.0.0/32"]
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "output", "init", "destroy"]

}

dependency "efs" {
  config_path = "../efs"

  mock_outputs = {
    efs_id              = "mock"
    efs_access_point_id = "mock"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "output", "init", "destroy"]

}

dependency "alb" {
  config_path = "../alb"

  mock_outputs = {
    alb_dns_name               = "mock"
    alb_target_group_arns      = ["arn:aws::::*/*"]
    alb_target_group_names     = ["mock"]
    alb_https_listener_arns    = ["mock"]
    alb_http_tcp_listener_arns = ["mock"]
    alb_sg                     = ["mock"]
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "output", "init", "destroy"]

}

dependency "rds" {
  config_path = "../rds"

  mock_outputs = {
    db_secrets_arn = "mock"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "output", "init", "destroy"]

}

inputs = {
  # vpc
  vpc_id              = dependency.vpc.outputs.vpc_id
  private_subnets     = dependency.vpc.outputs.private_subnets
  private_cidr_blocks = dependency.vpc.outputs.private_cidr_blocks
  public_subnets      = dependency.vpc.outputs.public_subnets
  public_cidr_blocks  = dependency.vpc.outputs.public_cidr_blocks

  # efs
  efs_id              = dependency.efs.outputs.efs_id
  efs_access_point_id = dependency.efs.outputs.efs_access_point_id

  # alb
  alb_dns_name               = dependency.alb.outputs.alb_dns_name
  alb_target_group_arns      = dependency.alb.outputs.alb_target_group_arns
  alb_target_group_names     = dependency.alb.outputs.alb_target_group_names
  alb_https_listener_arns    = dependency.alb.outputs.alb_https_listener_arns
  alb_http_tcp_listener_arns = dependency.alb.outputs.alb_http_tcp_listener_arns
  alb_sg                     = dependency.alb.outputs.alb_sg

  # rds
  db_secrets_arn = dependency.rds.outputs.db_secrets_arn
}
