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

  precondition {
    condition     = length(var.metric_drop_rules) == 0 || local.anchor_found
    error_message = "metric_drop_rules anchor not found in rendered k8s-monitoring template - upstream chart layout changed, update relabel_anchor in locals.tf"
  }
}
