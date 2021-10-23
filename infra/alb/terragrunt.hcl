include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id         = "mock"
    public_subnets = ["mock"]
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "output", "init", "destroy"]

}

inputs = {
  vpc_id         = dependency.vpc.outputs.vpc_id
  public_subnets = dependency.vpc.outputs.public_subnets
}
