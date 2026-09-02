locals {
  // x-release-please-start-version
  version = "1.1.16"
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

  # The Alloy config lives inside a YAML double-quoted scalar, so newlines and
  # quotes in the rendered template are the literal two-character sequences \n
  # and \" - generated blocks must be escaped the same way.
  metric_drop_configs = replace(replace(replace(join("", [
    for pattern in var.metric_drop_rules :
    "    write_relabel_config {\n      source_labels = [\"__name__\"]\n      regex = \"${pattern}\"\n      action = \"drop\"\n    }\n"
  ]), "\\", "\\\\"), "\"", "\\\""), "\n", "\\n")

  # Anchor on the endpoint-close / wal-open boundary, which is stable across
  # k8s-monitoring chart 4.x. The output precondition fails the plan if the
  # anchor disappears in a future chart bump, so the silent no-op from chart
  # 4.0.4 cannot recur.
  relabel_anchor = "}\\n\\n  wal {"
  anchor_found   = strcontains(local.rendered, local.relabel_anchor)
  yaml = (
    length(var.metric_drop_rules) == 0 || !local.anchor_found ? local.rendered :
    replace(local.rendered, local.relabel_anchor, "${local.metric_drop_configs}${local.relabel_anchor}")
  )

  secrets_yaml = templatefile("${path.module}/external-secrets.yaml.tftpl", {
    external_secrets_keys     = var.external_secrets_keys
    external_secret_store_ref = var.external_secret_store_ref
    logs_secret               = var.logs_secret
    metrics_secret            = var.metrics_secret
    traces_secret             = var.traces_secret
  })
}
