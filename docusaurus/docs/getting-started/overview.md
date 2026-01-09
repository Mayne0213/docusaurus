---
sidebar_position: 1
---

# Overview

## Infrastructure at a Glance

Our infrastructure is designed for **high availability**, **automation**, and **easy management**.

### Key Components

#### 🎯 Kubernetes (K3s)
- Lightweight Kubernetes distribution
- Running on Oracle Cloud Infrastructure
- Multi-node cluster for redundancy

#### 🔄 ArgoCD
- GitOps-based deployment
- Automatic synchronization from Git
- Declarative infrastructure management

#### 🔐 Security
- **cert-manager**: Automatic SSL/TLS certificates
- **External Secrets**: Vault integration for secrets management
- **Network Policies**: Fine-grained network access control

#### 📊 Monitoring
- **Prometheus**: Metrics collection
- **Grafana**: Visualization and dashboards
- **Loki**: Log aggregation
- **Alertmanager**: Alert management

### Infrastructure Layout

```
┌─────────────────────────────────────────┐
│          Load Balancer / Ingress        │
│         (nginx-ingress-controller)      │
└─────────────────┬───────────────────────┘
                  │
       ┌──────────┴──────────┐
       │                     │
┌──────▼──────┐    ┌────────▼────────┐
│   Master    │    │  Worker Nodes   │
│   Node      │    │                 │
│             │    │  - Applications │
│  - Control  │    │  - Services     │
│    Plane    │    │  - Monitoring   │
│  - ArgoCD   │    │                 │
└─────────────┘    └─────────────────┘
```

### Services Running

| Service | Purpose | URL |
|---------|---------|-----|
| Homer | Dashboard | https://homer0213.kro.kr |
| Gitea | Git Service | https://gitea0213.kro.kr |
| Grafana | Monitoring | https://grafana0213.kro.kr |
| Docusaurus | Documentation | https://docusaurus0213.kro.kr |

## Next Steps

- [Learn about the architecture](./architecture)
- [Explore Kubernetes setup](../services/kubernetes)
- [Set up monitoring](../services/monitoring)
