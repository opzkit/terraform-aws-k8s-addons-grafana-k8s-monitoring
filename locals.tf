locals {
  # x-release-please-version
  version = "1.6.8"
  yaml = templatefile("${path.module}/k8s-monitoring.yaml.tftpl", {
    cluster_name         = var.cluster_name
    logs_secret          = var.logs_secret
    logs_hostname_key    = var.logs_host_key
    logs_username_key    = var.logs_username_key
    logs_password_key    = var.logs_password_key
    metrics_secret       = var.metrics_secret
    metrics_hostname_key = var.metrics_host_key
    metrics_username_key = var.metrics_username_key
    metrics_password_key = var.metrics_password_key
    traces_secret        = var.traces_secret
    traces_hostname_key  = var.traces_host_key
    traces_username_key  = var.traces_username_key
    traces_password_key  = var.traces_password_key
  })
}
