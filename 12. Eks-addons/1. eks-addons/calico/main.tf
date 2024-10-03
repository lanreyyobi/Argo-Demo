/*
# Calico Operator installation
resource "kubectl_manifest" "calico_operator" {
  #depends_on = [null_resource.my_command]
  for_each           = data.kubectl_file_documents.calico_install.manifests
  yaml_body          = each.value
  #override_namespace = "default"
}



resource "null_resource" "my_eks" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region us-east-1 --name demo"
  }
}

resource "null_resource" "my_command" {
  depends_on = [null_resource.my_eks]
  provisioner "local-exec" {
    command = "kubectl delete daemonset -n kube-system aws-node"
  }
}


resource "null_resource" "my_command1" {
  depends_on = [null_resource.my_command]
  provisioner "local-exec" {
    command = "kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.3/manifests/tigera-operator.yaml"
  }
}
*/
# Calico config installation
resource "kubectl_manifest" "calico_config" {

  for_each           = data.kubectl_file_documents.calico_config.manifests
  yaml_body          = each.value
  #depends_on = [null_resource.my_command1]
}




/*
resource "helm_release" "calico" {
  name             = "calico"
  repository       = "https://projectcalico.docs.tigera.io/charts"
  chart            = "tigera-operator"
  namespace        = "tigera-operator"
  version          = "3.26.3"
  create_namespace = true

  set {
    name  = "kubernetesProvider"
    value = "EKS"
  }

  set {
    name  = "app.kubernetes.io/managed-by"
    value = "Helm"
  }

  set {
    name  = "meta.helm.sh/release-name"
    value = "calico"
  }

  set {
    name  = "meta.helm.sh/release-namespace"
    value = "tigera-operator"
  }
}
*/