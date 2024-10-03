data "aws_eks_cluster" "this" {
  name = ""
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.aws_eks_cluster.this.name
}

data "aws_vpc" "dev" {
  tags = {
    Name = "ek-vpc"
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.de.id]
  }
}

data "aws_subnets" "nodes" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.dev.id]
  }

  tags = {
    Name = var.subnet_tag
  }
}

data "aws_security_groups" "efs_sg" {
  filter {
    name   = "tag:Name"
    values = ["nf-efs"]
  }

  filter {
    name   = "vc-id"
    values = [data.aws_vpc.dev.id]
  }
}
