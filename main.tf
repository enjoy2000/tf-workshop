resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

data "aws_eks_cluster" "cluster" {
  name = module.my-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.my-cluster.cluster_id
}

data "aws_subnet_ids" "example" {
  vpc_id = aws_vpc.example.id
}

module "my-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-cluster"
  cluster_version = "1.19"
  subnets         = data.aws_subnet_ids.example.ids
  vpc_id          = aws_vpc.example.id

  worker_groups = [
    {
      instance_type = "t3.micro"
      asg_max_size  = 2
    }
  ]
}