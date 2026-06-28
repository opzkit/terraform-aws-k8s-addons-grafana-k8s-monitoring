locals {
  // x-release-please-start-version
  version = "1.1.12"
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
  # Injected inside the prometheus.remote_write "metricsservice" endpoint
  # block so matching metrics are dropped before remote write.
  metric_drop_configs = join("", [
    for pattern in var.metric_drop_rules :
    "        write_relabel_config {\n          source_labels = [\"__name__\"]\n          regex = \"${pattern}\"\n          action = \"drop\"\n        }\n"
  ])

  # Anchor on the endpoint-close / wal-open boundary, which is stable across
  # k8s-monitoring chart 4.x. Fail fast if the anchor disappears in a future
  # chart bump so the silent no-op from chart 4.0.4 cannot recur.
  relabel_anchor      = "      }\n\n      wal {"
  relabel_replacement = "${local.metric_drop_configs}      }\n\n      wal {"
  yaml = (
    length(var.metric_drop_rules) == 0 ? local.rendered :
    strcontains(local.rendered, local.relabel_anchor) ? replace(local.rendered, local.relabel_anchor, local.relabel_replacement) :
    file("ERROR: metric_drop_rules anchor not found in rendered k8s-monitoring template - upstream chart layout changed, update relabel_anchor in locals.tf")
  )

  secrets_yaml = templatefile("${path.module}/external-secrets.yaml.tftpl", {
    external_secrets_keys     = var.external_secrets_keys
    external_secret_store_ref = var.external_secret_store_ref
    logs_secret               = var.logs_secret
    metrics_secret            = var.metrics_secret
    traces_secret             = var.traces_secret
  })
}
