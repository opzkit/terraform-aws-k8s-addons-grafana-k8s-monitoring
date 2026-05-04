locals {
  // x-release-please-start-version
  version = "1.1.4"
  // x-release-please-end
  replaced = replace(file("${path.module}/k8s-monitoring.yaml.tftpl"), "$${1}", "$$$${1}")
  rendered = replace(templatestring(local.replaced, {
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

  # Generate write_relabel_config blocks for each metric drop rule.
  # These are injected into all prometheus.remote_write endpoints to
  # prevent matching metrics from being sent to the remote backend.
  metric_drop_configs = join("", [
    for pattern in var.metric_drop_rules :
    "        write_relabel_config {\n          source_labels = [\"__name__\"]\n          regex = \"${pattern}\"\n          action = \"drop\"\n        }\n"
  ])

  # Inject drop rules after the last write_relabel_config in each
  # prometheus.remote_write block (the k8s_cluster_name relabel rule).
  relabel_anchor      = "target_label = \"k8s_cluster_name\"\n        }"
  relabel_replacement = "target_label = \"k8s_cluster_name\"\n        }\n${local.metric_drop_configs}"
  yaml                = length(var.metric_drop_rules) > 0 ? replace(local.rendered, local.relabel_anchor, local.relabel_replacement) : local.rendered

  secrets_yaml = templatefile("${path.module}/external-secrets.yaml.tftpl", {
    external_secrets_keys     = var.external_secrets_keys
    external_secret_store_ref = var.external_secret_store_ref
    logs_secret               = var.logs_secret
    metrics_secret            = var.metrics_secret
    traces_secret             = var.traces_secret
  })
}
