terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

resource "kubectl_manifest" "karpenter_node_class" {
  yaml_body = templatefile("${path.module}/templates/node-class.yaml.tpl", {
    name               = var.name
    cluster_name       = var.cluster_name
    node_iam_role_name = var.node_iam_role_name
  })
}

resource "kubectl_manifest" "karpenter_node_pool" {
  yaml_body = templatefile("${path.module}/templates/node-pool.yaml.tpl", {
    name                 = var.name
    labels               = jsonencode(var.labels)
    taints               = jsonencode(var.taints)
    instance_category    = jsonencode(var.instance_category)
    instance_cpu         = jsonencode(var.instance_cpu)
    instance_hypervisor  = jsonencode(var.instance_hypervisor)
    capacity_type        = jsonencode(var.capacity_type)
    arch                 = jsonencode(var.arch)
    consolidation_policy = var.consolidation_policy
    consolidate_after    = var.consolidate_after
  })

  depends_on = [
    kubectl_manifest.karpenter_node_class
  ]
}