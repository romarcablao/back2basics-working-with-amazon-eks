terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "iam_role" {
  name               = "${var.cluster_name}-ebs-csi"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_eks_pod_identity_association" "eks_pod_identity_association_controller" {
  cluster_name    = var.cluster_name
  namespace       = "kube-system"
  service_account = "ebs-csi-controller-sa"
  role_arn        = aws_iam_role.iam_role.arn
}

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name                = var.cluster_name
  addon_name                  = "aws-ebs-csi-driver"
  resolve_conflicts_on_update = "OVERWRITE"
}

resource "kubectl_manifest" "ebs_storage_class" {
  depends_on = [
    aws_eks_addon.ebs_csi_driver
  ]

  yaml_body = <<-EOF
    kind: StorageClass
    apiVersion: storage.k8s.io/v1
    metadata:
      name: gp3
      annotations:
        storageclass.kubernetes.io/is-default-class: 'true'
    provisioner: ebs.csi.aws.com
    volumeBindingMode: WaitForFirstConsumer
    parameters:
      type: 'gp3'
    EOF
}