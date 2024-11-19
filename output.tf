output "addons" {
  value = [
    {
      name : "grafana-k8s-monitoring"
      version : local.version
      content : local.yaml
    }
  ]
}
