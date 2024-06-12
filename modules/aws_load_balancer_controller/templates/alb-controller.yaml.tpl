image:
  repository: public.ecr.aws/eks/aws-load-balancer-controller

serviceAccount:
  create: true
  name: ${service_name}

tolerations:
- key: "critical-workloads"
  operator: "Exists"
  effect: "NoSchedule"

nodeSelector:
  app: critical-workloads

clusterName: ${cluster_name}
region: ${region}
vpcId: ${vpc_id}