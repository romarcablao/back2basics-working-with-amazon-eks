# Back2Basics Series: Working With Amazon Elastic Kubernetes Service (EKS)


## Installation
> Depending on your OS, select the installation method here: https://opentofu.org/docs/intro/install/

## Provision the infrastructure
1. Make necessary adjustment on the variables.
2. Run `tofu init` to initialize the modules and other necessary resources.
3. Run `tofu plan` to check what will be created/deleted.
4. Run `tofu apply` to apply the changes. Type `yes` when asked to proceed.

## Fetch `kubeconfig` to access the cluster
```bash
aws eks update-kubeconfig --region $REGION --name $CLUSTER_NAME
```

## Check what's inside the cluster
```bash
# List all pods in all namespaces
kubectl get pods -A

# List all deployments in kube-system
kubectl get deployment -n kube-system

# List all daemonsets in kube-system
kubectl get daemonset -n kube-system

# List all nodes
kubectl get nodes
```

## Let's try to deploy a simple app
```bash
# Create a deployment
kubectl create deployment my-app --image nginx

# Scale the replicas of my-app deployment
kubectl scale deployment/my-app --replicas 2

# Check the pods
kubectl get pods

# Delete the deployment
kubectl delete deployment my-app
```

