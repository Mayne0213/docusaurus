---
sidebar_position: 3
---

# Monitoring Stack

## Overview

Our monitoring stack provides complete observability with metrics, logs, and visualization.

## Components

### Prometheus

**Metrics collection and storage**

- Scrapes metrics from all services
- Stores time-series data
- Powers alerting rules

Access: Internal only (no direct UI exposure)

### Grafana

**Visualization and dashboards**

- Beautiful dashboards
- Query Prometheus data
- Alert management UI

Access: https://grafana0213.kro.kr

### Loki

**Log aggregation**

- Collects logs from all pods
- Indexed for fast searching
- Integrated with Grafana

### Promtail

**Log shipping agent**

- Runs on each node
- Forwards logs to Loki
- Adds metadata labels

### Alertmanager

**Alert routing and notification**

- Receives alerts from Prometheus
- Routes to correct channels
- Deduplication and grouping

## Dashboards

### Pre-built Dashboards

1. **Cluster Overview**
   - Node health
   - Resource usage
   - Pod status

2. **Application Metrics**
   - Request rate
   - Error rate
   - Response time

3. **Infrastructure**
   - CPU, Memory, Disk
   - Network traffic
   - Storage usage

### Creating Custom Dashboards

```bash
# Export existing dashboard
curl -s http://grafana:3000/api/dashboards/uid/<uid> > dashboard.json

# Import via UI
Grafana → Dashboards → Import → Upload JSON
```

## Querying Metrics

### PromQL Examples

```promql
# CPU usage by pod
rate(container_cpu_usage_seconds_total[5m])

# Memory usage
container_memory_working_set_bytes

# HTTP request rate
rate(http_requests_total[5m])

# Error rate
rate(http_requests_total{status=~"5.."}[5m])
```

## Alerts

### Viewing Alerts

```bash
# List Prometheus rules
sudo kubectl get prometheusrules -n monitoring

# View Alertmanager status
sudo kubectl get alertmanagers -n monitoring
```

### Common Alerts

- **HighCPUUsage**: Pod using >80% CPU
- **HighMemoryUsage**: Pod using >80% memory
- **PodCrashLooping**: Pod restarting frequently
- **DiskSpaceLow**: Node disk >85% full

## Log Queries

### LogQL Examples

```logql
# All logs from a namespace
{namespace="my-app"}

# Error logs
{namespace="my-app"} |= "error"

# Parse JSON logs
{namespace="my-app"} | json | level="error"

# Count errors
count_over_time({namespace="my-app"} |= "error" [5m])
```

## Accessing Monitoring Data

### Grafana UI

1. Navigate to https://grafana0213.kro.kr
2. Log in with credentials
3. Browse dashboards or create queries

### Port Forwarding (Development)

```bash
# Prometheus UI
sudo kubectl port-forward -n monitoring svc/prometheus-operated 9090:9090

# Access at http://localhost:9090

# Alertmanager UI
sudo kubectl port-forward -n monitoring svc/alertmanager-operated 9093:9093

# Access at http://localhost:9093
```

## Troubleshooting

### No Metrics Showing

```bash
# Check Prometheus targets
sudo kubectl exec -n monitoring prometheus-0 -- promtool check config /etc/prometheus/prometheus.yml

# Verify service monitors
sudo kubectl get servicemonitors -A
```

### Grafana Not Loading Data

```bash
# Check Grafana logs
sudo kubectl logs -n monitoring deployment/grafana

# Verify datasource configuration
sudo kubectl get secret -n monitoring grafana-datasources -o yaml
```

### High Cardinality Issues

Too many unique label combinations can cause performance issues:

```bash
# Check series count
curl http://prometheus:9090/api/v1/status/tsdb | jq '.data.seriesCountByMetricName'
```

## Best Practices

1. **Set up alerts proactively**: Don't wait for incidents
2. **Use labels wisely**: Avoid high cardinality
3. **Create focused dashboards**: One purpose per dashboard
4. **Set retention policies**: Balance storage vs history
5. **Document custom metrics**: Help future maintainers

## Metrics to Monitor

### Application Level
- Request rate
- Error rate
- Response time (latency)
- Saturation (queue depth)

### Infrastructure Level
- CPU usage
- Memory usage
- Disk I/O
- Network throughput

### Business Level (Optional)
- User signups
- Active sessions
- Feature usage
- Transaction volume

## Next Steps

- [Kubernetes Operations](./kubernetes)
- [ArgoCD Configuration](./argocd)
