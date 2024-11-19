locals {
  version = "0.43.3"
  yaml = templatefile("${path.module}/k8s-monitoring.yaml.tftpl", {
    cluster_name         = var.cluster_name
    logs_secret          = var.logs_secret
    logs_username_key    = var.logs_username_key
    logs_password_key    = var.logs_password_key
    metrics_secret       = var.metrics_secret
    metrics_host         = var.metrics_host
    metrics_username_key = var.metrics_username_key
    metrics_password_key = var.metrics_password_key
    traces_secret        = var.traces_secret
    traces_username_key  = var.traces_username_key
    traces_password_key  = var.traces_password_key
  })
}
