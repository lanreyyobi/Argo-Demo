
locals {
  istio_charts_url = "https://istio-release.storage.googleapis.com/charts"
}

#Istio namespace
resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
  }
}

# Istio base release
resource "helm_release" "istio-base" {
  repository      = local.istio_charts_url
  chart           = "base"
  name            = "istio-base"
  namespace       = kubernetes_namespace.istio_system.id
  cleanup_on_fail = true
  force_update    = false

  depends_on = [kubernetes_namespace.istio_system]
}

# Istiod release
resource "helm_release" "istiod" {
  repository      = local.istio_charts_url
  chart           = "istiod"
  name            = "istiod"
  namespace       = kubernetes_namespace.istio_system.id
  cleanup_on_fail = true
  force_update    = false

  depends_on = [helm_release.istio-base]
}

# Default namespace labelistio-system
resource "kubernetes_labels" "example" {
  api_version = "v1"
  kind        = "Namespace"
  metadata {
    name = "default"
  }
  labels = {
    istio-injection = "enabled"
  }
}

# Istio ingress
resource "helm_release" "istio-ingress" {
  repository      = local.istio_charts_url
  chart           = "gateway"
  name            = "istio-ingressgateway"
  namespace       = kubernetes_namespace.istio_system.id
  cleanup_on_fail = true
  force_update    = false

  depends_on = [helm_release.istiod]
}

#Istio egress
resource "helm_release" "istio-egress" {
  repository      = local.istio_charts_url
  chart           = "gateway"
  name            = "istio-egress"
  namespace       = kubernetes_namespace.istio_system.id
  cleanup_on_fail = true
  force_update    = false

  depends_on = [helm_release.istiod]
}

#Kiali dashboard
resource "kubectl_manifest" "kiali" {
  for_each           = data.kubectl_file_documents.kiali.manifests
  yaml_body          = each.value
  override_namespace = "istio-system"

  depends_on = [helm_release.istio-ingress]
}

data "kubectl_file_documents" "kiali" {
  content = file("${path.module}/manifests/kiali.yaml")
}
/*
# Book info application
resource "kubectl_manifest" "book-info" {
  for_each           = data.kubectl_file_documents.book-info.manifests
  yaml_body          = each.value
  override_namespace = "default"

  depends_on = [kubectl_manifest.kiali]
}

data "kubectl_file_documents" "book-info" {
  content = file("${path.module}/manifests/bookinfo.yaml")
}
*/

# Book info application
resource "kubectl_manifest" "car-tracker" {
  for_each           = data.kubectl_file_documents.car-tracker.manifests
  yaml_body          = each.value
  override_namespace = "default"

  depends_on = [kubectl_manifest.kiali]
}

data "kubectl_file_documents" "car-tracker" {
  content = file("${path.module}/manifests/car-tracker.yaml")
}

# Prometheus deployment
resource "kubectl_manifest" "prometheus" {
  for_each           = data.kubectl_file_documents.prometheus.manifests
  yaml_body          = each.value
  override_namespace = "istio-system"

  depends_on = [kubectl_manifest.kiali]
}

data "kubectl_file_documents" "prometheus" {
  content = file("${path.module}/manifests/prometheus.yaml")
}

#Grafana dashboard
resource "kubectl_manifest" "grafana" {
  for_each           = data.kubectl_file_documents.grafana.manifests
  yaml_body          = each.value
  override_namespace = "istio-system"

  depends_on = [kubectl_manifest.prometheus]
}

data "kubectl_file_documents" "grafana" {
  content = file("${path.module}/manifests/grafana.yaml")
}

#Jaegar
resource "kubectl_manifest" "jaeger" {
  for_each           = data.kubectl_file_documents.jaegar.manifests
  yaml_body          = each.value
  override_namespace = "istio-system"

  depends_on = [kubectl_manifest.kiali]
}

data "kubectl_file_documents" "jaegar" {
  content = file("${path.module}/manifests/jaeger.yaml")
}

