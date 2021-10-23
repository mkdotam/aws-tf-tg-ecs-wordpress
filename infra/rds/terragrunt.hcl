include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id              = "mock"
    database_subnets    = ["mock"]
    private_cidr_blocks = ["0.0.0.0/32"]
    public_cidr_blocks  = ["0.0.0.0/32"]
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "output", "init", "destroy"]
}

inputs = {
  vpc_id              = dependency.vpc.outputs.vpc_id
  database_subnets    = dependency.vpc.outputs.database_subnets
  private_cidr_blocks = dependency.vpc.outputs.private_cidr_blocks
  public_cidr_blocks  = dependency.vpc.outputs.public_cidr_blocks
}
