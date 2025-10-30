locals {
  // x-release-please-start-version
  version = "0.8.21"
  // x-release-please-end
  replaced = replace(file("${path.module}/k8s-monitoring.yaml.tftpl"), "$${1}", "$$$${1}")
  yaml = replace(templatestring(local.replaced, {
    cluster_name         = var.cluster_name
    logs_secret          = var.logs_secret
    logs_url             = var.logs_url
    logs_username_key    = var.logs_username_key
    logs_password_key    = var.logs_password_key
    metrics_secret       = var.metrics_secret
    metrics_url          = var.metrics_url
    cost_metrics_url     = var.cost_metrics_url
    metrics_username_key = var.metrics_username_key
    metrics_password_key = var.metrics_password_key
    traces_secret        = var.traces_secret
    traces_host          = var.traces_host
    traces_username_key  = var.traces_username_key
    traces_password_key  = var.traces_password_key
  }), "$$", "$")

  secrets_yaml = templatefile("${path.module}/external-secrets.yaml.tftpl", {
    external_secrets_keys     = var.external_secrets_keys
    external_secret_store_ref = var.external_secret_store_ref
    logs_secret               = var.logs_secret
    metrics_secret            = var.metrics_secret
    traces_secret             = var.traces_secret
  })
}
