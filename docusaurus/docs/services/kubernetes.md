---
sidebar_position: 1
---

# Kubernetes (K3s)

## Overview

We use **K3s**, a lightweight Kubernetes distribution, as our container orchestration platform.

## Cluster Setup

### Nodes

- **Master Node**: `oracle-master`
  - Control plane components
  - etcd database
  - ArgoCD installation

- **Worker Nodes**: `mayne-worker-1`, `mayne-worker-2`, etc.
  - Application workloads
  - Monitoring stack
  - Service deployments

### Access

```bash
# SSH to master node
ssh oracle-master

# Use kubectl (requires sudo on master)
sudo kubectl get nodes
sudo kubectl get pods -A
```

## Common Operations

### View All Resources

```bash
# Get all namespaces
sudo kubectl get namespaces

# Get all pods in all namespaces
sudo kubectl get pods -A

# Get services
sudo kubectl get services -A
```

### Check Application Status

```bash
# Check specific namespace
sudo kubectl get all -n <namespace>

# View pod logs
sudo kubectl logs -n <namespace> <pod-name>

# Describe pod for troubleshooting
sudo kubectl describe pod -n <namespace> <pod-name>
```

### Managing Applications

Most applications are managed by ArgoCD, so manual kubectl operations are rarely needed.

```bash
# Check ArgoCD applications
sudo kubectl get applications -n argocd

# Force sync an application (if needed)
sudo kubectl patch application -n argocd <app-name> \
  -p '{"metadata": {"annotations": {"argocd.argoproj.io/refresh": "hard"}}}' \
  --type merge
```

## Namespaces

Each service runs in its own namespace for isolation:

| Namespace | Purpose |
|-----------|---------|
| `argocd` | ArgoCD deployment |
| `cert-manager` | Certificate management |
| `ingress-nginx` | Ingress controller |
| `monitoring` | Prometheus, Grafana |
| `gitea` | Git service |
| `vault` | Secrets management |

## Storage

### Storage Classes

- **local-path**: Default storage class
  - Uses local disk on worker nodes
  - Good for development and non-critical data

### Persistent Volumes

```bash
# View PVCs
sudo kubectl get pvc -A

# View PVs
sudo kubectl get pv
```

## Networking

### Ingress

External traffic flows through nginx-ingress-controller:

```
Internet → nginx-ingress → Service → Pod
```

### Services

- **ClusterIP**: Internal only (default)
- **LoadBalancer**: External access (rarely used)
- **Ingress**: HTTPS with custom domains

## Troubleshooting

### Pod Not Starting

```bash
# Check pod events
sudo kubectl describe pod -n <namespace> <pod-name>

# Check logs
sudo kubectl logs -n <namespace> <pod-name>

# Check previous container logs (if crashed)
sudo kubectl logs -n <namespace> <pod-name> --previous
```

### Resource Issues

```bash
# Check node resources
sudo kubectl top nodes

# Check pod resources
sudo kubectl top pods -A
```

### Network Issues

```bash
# Check services
sudo kubectl get svc -A

# Check ingress
sudo kubectl get ingress -A

# Test connectivity from a pod
sudo kubectl run -it --rm debug --image=nicolaka/netshoot --restart=Never -- /bin/bash
```

## Best Practices

1. **Use namespaces** for logical separation
2. **Set resource limits** on all containers
3. **Use health checks** (readiness and liveness probes)
4. **Label everything** for better organization
5. **Don't run as root** (use securityContext)

## Next Steps

- [ArgoCD Setup](./argocd)
- [Monitoring Stack](./monitoring)
