apiVersion: karpenter.sh/v1beta1
kind: NodePool
metadata:
  name: ${name}
spec:
  template:
    metadata:
      labels: ${labels}
    spec:
      nodeClassRef:
        name: ${name}
      taints: ${taints}
      requirements:
        - key: "karpenter.k8s.aws/instance-category"
          operator: In
          values: ${instance_category}
        - key: "karpenter.k8s.aws/instance-cpu"
          operator: In
          values: ${instance_cpu}
        - key: "karpenter.k8s.aws/instance-hypervisor"
          operator: In
          values: ${instance_hypervisor}
        - key: "kubernetes.io/arch"
          operator: In
          values: ${arch}
        - key: "karpenter.sh/capacity-type"
          operator: In
          values: ${capacity_type}
        - key: "karpenter.k8s.aws/instance-generation"
          operator: Gt
          values: ["2"]
      kubelet:
        systemReserved:
          cpu: 100m
          memory: 100Mi
          ephemeral-storage: 1Gi
        kubeReserved:
          cpu: 200m
          memory: 100Mi
          ephemeral-storage: 3Gi
        evictionMaxPodGracePeriod: 60
        imageGCHighThresholdPercent: 85
        imageGCLowThresholdPercent: 80
  limits:
    cpu: 1000
  disruption:
    consolidationPolicy: ${consolidation_policy}
    consolidateAfter: ${consolidate_after}