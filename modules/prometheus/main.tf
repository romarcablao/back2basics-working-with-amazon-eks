resource "helm_release" "prometheus" {
  chart            = "prometheus"
  version          = var.addon_version
  name             = "prometheus"
  namespace        = "prometheus"
  create_namespace = true
  repository       = "https://prometheus-community.github.io/helm-charts"

  values = [templatefile("${path.module}/templates/prometheus.yaml.tpl", {
    service_name = "prometheus"
  })]
}
