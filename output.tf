output "addons" {
  value = [
    {
      name : "grafana-k8s-monitoring"
      version : local.version
      content : local.yaml
    },
    {
      name : "grafana-k8s-monitoring-secrets"
      version : local.version
      content : local.secrets_yaml
    }
  ]
}
