data "aws_eks_cluster" "this" {
  name = "demo"
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.aws_eks_cluster.this.name
}

data "aws_vpc" "dev" {
  tags = {
    Name = "eks-vpc"
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.dev.id]
  }
}

data "aws_subnets" "nodes" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.dev.id]
  }

  tags = {
    Name = var.subnet_tags
  }
}

data "aws_security_groups" "efs_sg" {
  filter {
    name   = "tag:Name"
    values = ["nfs-efs"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.dev.id]
  }
}