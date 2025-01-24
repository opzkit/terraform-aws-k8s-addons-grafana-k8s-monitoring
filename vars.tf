variable "logs_url" {
  type        = string
  description = "URL for Loki. NOTE this is a full data writing/pushing URL, not just the hostname!"
}

variable "logs_secret" {
  type        = string
  default     = "loki"
  description = "Name of secret containing auth information for Loki"
}

variable "logs_username_key" {
  type        = string
  default     = "username"
  description = "Key in logs secret containing username for Loki"
}

variable "logs_password_key" {
  type        = string
  default     = "password"
  description = "Key in logs secret containing password for Loki"
}

variable "traces_url" {
  type        = string
  description = "URL for Tempo. NOTE this is a full data writing/pushing URL, not just the hostname!"
}

variable "traces_secret" {
  type        = string
  default     = "tempo"
  description = "Name of secret containing auth information for Tempo"
}

variable "traces_username_key" {
  type        = string
  default     = "username"
  description = "Key in traces secret containing username for Tempo"
}

variable "traces_password_key" {
  type        = string
  default     = "password"
  description = "Key in traces secret containing password for Tempo"
}

variable "metrics_url" {
  type        = string
  description = "URL for Prometheus. NOTE this is a full data writing/pushing URL, not just the hostname!"
}

variable "cost_metrics_url" {
  type        = string
  description = "URL for Prometheus for OpenCost. NOTE this is usually just the hostname!"
}

variable "metrics_secret" {
  type        = string
  default     = "prometheus"
  description = "Name of secret containing auth information for Prometheus"
}

variable "metrics_username_key" {
  type        = string
  default     = "username"
  description = "Key in metrics secret containing username for Prometheus"
}

variable "metrics_password_key" {
  type        = string
  default     = "password"
  description = "Key in metrics secret containing password for Prometheus"
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
}

variable "external_secret_store_ref" {
  type = object({
    kind : string
    name : string
  })
  default = {
    kind : "ClusterSecretStore"
    name : "external-secrets"
  }
  description = "External secret store reference to use if external_secrets_keys are provided"
}

variable "external_secrets_keys" {
  type = object({
    loki : string,
    tempo : string,
    prometheus : string
  })
  default     = null
  description = "External secrets keys for Loki, Prometheus and Tempo. If set external secrets will be created"
  validation {
    condition     = var.external_secrets_keys == null ? true : length(var.external_secrets_keys.loki) > 0
    error_message = "Must supply values for loki"
  }
  validation {
    condition     = var.external_secrets_keys == null ? true : length(var.external_secrets_keys.tempo) > 0
    error_message = "Must supply values for tempo"
  }
  validation {
    condition     = var.external_secrets_keys == null ? true : length(var.external_secrets_keys.prometheus) > 0
    error_message = "Must supply values for prometheus"
  }
}
