resource "helm_release" "prometheus" {
  chart            = "metrics-server"
  version          = var.addon_version
  name             = "metrics-server"
  namespace        = "metrics-server"
  create_namespace = true
  repository       = "https://kubernetes-sigs.github.io/metrics-server/"

  values = [templatefile("${path.module}/templates/metrics-server.yaml.tpl", {
    cluster_name = var.cluster_name
  })]
}
