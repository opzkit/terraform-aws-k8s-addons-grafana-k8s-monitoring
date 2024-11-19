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

variable "traces_secret" {
  type        = string
  default     = "tempo"
  description = "Name of secret containing auth information for Tempo"
}

variable "traces_username_key" {
  type        = string
  default     = "username"
  description = "Key in logs secret containing username for Tempo"
}

variable "traces_password_key" {
  type        = string
  default     = "password"
  description = "Key in logs secret containing password for Tempo"
}

variable "metrics_host" {
  type        = string
  description = "The URL to use to push Prometheus metrics to"
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

