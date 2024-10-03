data "aws_eks_cluster" "this" {
  name = "demo"
}

output "id" {
  value = data.aws_eks_cluster.this.cluster_id
}