# module "karpenter" {
#   source  = "terraform-aws-modules/eks/aws//modules/karpenter"
#   version = "~> 20.13"

#   cluster_name = module.eks.cluster_name

#   enable_pod_identity             = true
#   create_pod_identity_association = true

#   namespace          = "karpenter"
#   iam_policy_name    = "${module.eks.cluster_name}-karpenter-controller"
#   iam_role_name      = "${module.eks.cluster_name}-karpenter-controller"
#   node_iam_role_name = "${module.eks.cluster_name}-karpenter-node"
#   queue_name         = "karpenter-${module.eks.cluster_name}"

#   node_iam_role_additional_policies = {
#     AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#   }

#   tags = var.default_tags
# }

# resource "helm_release" "karpenter" {
#   namespace        = "karpenter"
#   name             = "karpenter"
#   repository       = "oci://public.ecr.aws/karpenter"
#   chart            = "karpenter"
#   version          = "0.36.1"
#   create_namespace = true
#   wait             = true

#   values = [
#     <<-EOT
#     nodeSelector:
#       node: initial
#     tolerations:
#       - key: node
#         value: initial
#         operator: Equal
#         effect: NoSchedule
#     settings:
#       clusterName: ${module.eks.cluster_name}
#       clusterEndpoint: ${module.eks.cluster_endpoint}
#       interruptionQueue: ${module.karpenter.queue_name}
#     EOT
#   ]

#   depends_on = [
#     module.eks,
#     module.karpenter
#   ]
# }

# module "karpenter_node_default" {
#   source = "./modules/karpenter_node"

#   name                 = "default"
#   cluster_name         = module.eks.cluster_name
#   node_iam_role_name   = module.karpenter.node_iam_role_name
#   consolidation_policy = "WhenEmpty"
#   consolidate_after    = "60s"

#   depends_on = [
#     helm_release.karpenter
#   ]
# }

# module "karpenter_node_critical_workloads" {
#   source = "./modules/karpenter_node"

#   name                 = "critical-workloads"
#   cluster_name         = module.eks.cluster_name
#   node_iam_role_name   = module.karpenter.node_iam_role_name
#   consolidation_policy = "WhenEmpty"
#   consolidate_after    = "60s"

#   capacity_type = ["on-demand"]

#   labels = {
#     app = "critical-workloads"
#   }
#   taints = [
#     { key = "critical-workloads", effect = "NoSchedule" }
#   ]

#   depends_on = [
#     helm_release.karpenter
#   ]
# }

# module "karpenter_node_vote_app" {
#   source = "./modules/karpenter_node"

#   name               = "vote-app"
#   cluster_name       = module.eks.cluster_name
#   node_iam_role_name = module.karpenter.node_iam_role_name
#   labels = {
#     app = "vote-app"
#   }
#   taints = [
#     { key = "app", value = "vote-app", effect = "NoSchedule" }
#   ]
#   capacity_type        = ["spot"]
#   consolidation_policy = "WhenUnderutilized"

#   depends_on = [
#     helm_release.karpenter
#   ]
# }

# module "karpenter_node_grafana" {
#   source = "./modules/karpenter_node"

#   name               = "grafana"
#   cluster_name       = module.eks.cluster_name
#   node_iam_role_name = module.karpenter.node_iam_role_name
#   labels = {
#     app = "grafana"
#   }
#   taints = [
#     { key = "app", value = "grafana", effect = "NoSchedule" }
#   ]
#   capacity_type        = ["spot"]
#   consolidation_policy = "WhenEmpty"
#   consolidate_after    = "60s"

#   depends_on = [
#     helm_release.karpenter
#   ]
# }