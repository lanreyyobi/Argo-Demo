# Cluster data
data "aws_eks_cluster" "cluster" {
  name = "demo"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "demo"
}

# Namespace
data "kubectl_file_documents" "calico_config" {
  content = file("${path.module}/manifests/calico-install.yaml")
}

# Argo CRD installation
data "kubectl_file_documents" "calico_install" {
  content = file("${path.module}/manifests/calico.yaml")
}
