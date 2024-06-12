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

resource "aws_iam_policy" "iam_policy" {
  policy = file("${path.module}/templates/iam-policy.json.tpl")
}

resource "aws_iam_role" "iam_role" {
  name               = "${var.cluster_name}-aws-load-balancer-controller"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.iam_policy.arn
}

resource "aws_eks_pod_identity_association" "eks_pod_identity_association" {
  cluster_name    = var.cluster_name
  namespace       = var.namespace
  service_account = "aws-load-balancer-controller"
  role_arn        = aws_iam_role.iam_role.arn
}

resource "helm_release" "aws_load_balancer_controller" {
  chart      = "aws-load-balancer-controller"
  version    = var.addon_version
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  namespace  = "kube-system"

  values = [templatefile("${path.module}/templates/alb-controller.yaml.tpl", {
    cluster_name = var.cluster_name
    region       = var.region
    vpc_id       = var.cluster_vpc_id
    service_name = "aws-load-balancer-controller"
  })]

}
