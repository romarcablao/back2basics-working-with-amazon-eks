resource "helm_release" "grafana" {
  chart            = "grafana"
  version          = var.addon_version
  name             = "grafana"
  namespace        = "grafana"
  create_namespace = true
  repository       = "https://grafana.github.io/helm-charts"

  values = [templatefile("${path.module}/templates/grafana.yaml.tpl", {
    service_name = "grafana"
  })]
}
