tolerations:
- key: "critical-workloads"
  operator: "Exists"
  effect: "NoSchedule"

nodeSelector:
  app: critical-workloads
