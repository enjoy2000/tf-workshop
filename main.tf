data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.78.0"

  name = var.project
  azs  = data.aws_availability_zones.available.names

  cidr = "10.0.0.0/16"
  private_subnets = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  public_subnets = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}

data "aws_subnet_ids" "example" {
  vpc_id = module.vpc.vpc_id

  depends_on = [
    module.vpc,
  ]
}

module "my-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.project
  cluster_version = "1.19"
  subnets         = data.aws_subnet_ids.example.ids
  vpc_id          = module.vpc.vpc_id

  worker_groups = [
    {
      instance_type = "t2.small"
      asg_max_size  = 2
      root_volume_type = "gp2"
    }
  ]
}