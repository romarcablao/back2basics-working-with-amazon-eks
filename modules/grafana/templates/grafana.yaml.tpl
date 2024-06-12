serviceAccount:
  create: true
  name: ${service_name}

autoscaling:
  enabled: true
  minReplicas: 1
  maxReplicas: 5
  targetCPU: "60"
  targetMemory: ""
  behavior: {}

tolerations:
- key: "grafana"
  operator: "Exists"
  effect: "NoSchedule"

nodeSelector:
  app: grafana

affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 100
      podAffinityTerm:
        labelSelector:
          matchLabels:
            app.kubernetes.io/name: grafana
            app.kubernetes.io/instance: grafana
        topologyKey: topology.kubernetes.io/zone