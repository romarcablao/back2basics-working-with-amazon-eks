module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.13"

  cluster_name                   = var.cluster_name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = true

  cluster_addons = {
    vpc-cni = {
      before_compute = true
      most_recent    = true
      configuration_values = jsonencode({
        env = {
          ENABLE_POD_ENI                    = "true"
          ENABLE_PREFIX_DELEGATION          = "true"
          POD_SECURITY_GROUP_ENFORCING_MODE = "standard"
        }
        nodeAgent = {
          enablePolicyEventLogs = "true"
        }
        enableNetworkPolicy = "true"
      })
    }
    coredns = {
      most_recent                 = true
      resolve_conflicts_on_update = "OVERWRITE"
      configuration_values = jsonencode({
        autoScaling = {
          enabled = true
        }
        tolerations = [
          {
            key      = "node"
            value    = "initial"
            operator = "Equal"
            effect   = "NoSchedule"
          }
        ]
      })
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  create_cluster_security_group = false
  create_node_security_group    = false

  eks_managed_node_groups = {
    default = {
      instance_types       = ["t3a.small", "t3a.large"]
      force_update_version = true

      min_size     = 0
      max_size     = 3
      desired_size = 2

      update_config = {
        max_unavailable_percentage = 50
      }

      labels = {
        default = "true"
        node    = "initial"
      }

      # Uncomment this if you will use Karpenter
      # taints = {
      #   init = {
      #     key    = "node"
      #     value  = "initial"
      #     effect = "NO_SCHEDULE"
      #   }
      # }
    }
  }

  enable_cluster_creator_admin_permissions = true

  tags = merge(var.default_tags, {
    "karpenter.sh/discovery" = var.cluster_name
  })
}