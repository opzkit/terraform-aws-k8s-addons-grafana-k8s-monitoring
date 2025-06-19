locals {
  zone       = "example.com"
  name       = "k8s.${local.zone}"
  region     = "eu-west-1"
  account_id = "012345678901"
}

resource "aws_iam_role" "kubernetes_admin" {
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Condition = {}
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.account_id}:root"
        }
      },
    ]
    Version = "2012-10-17"
  })
  description = "Kubernetes administrator role (for AWS IAM Authenticator for Kubernetes)."
}

module "k8s_monitoring" {
  source       = "../../"
  cluster_name = local.name
  external_secrets_keys = {
    loki : "services/grafana/loki",
    tempo : "services/grafana/tempo",
    prometheus : "services/grafana/prometheus"
  }
  logs_url         = "https://logs-prod-eu-west-0.grafana.net/loki/api/v1/push"
  metrics_url      = "https://prometheus-prod-01-eu-west-0.grafana.net/api/prom/push"
  cost_metrics_url = "https://prometheus-prod-01-eu-west-0.grafana.net/api/prom"
  traces_host      = "tempo-eu-west-0.grafana.net"

}

module "state_store" {
  source           = "github.com/opzkit/terraform-aws-kops-state-store?ref=v0.6.1"
  state_store_name = "some-kops-storage-s3-bucket"
}

module "k8s-network" {
  source              = "github.com/opzkit/terraform-aws-k8s-network?ref=v0.1.2"
  name                = "network"
  region              = local.region
  public_subnet_zones = ["a", "b", "c"]
  vpc_cidr            = "172.20.0.0/16"
}

module "k8s" {
  depends_on         = [module.state_store]
  source             = "github.com/opzkit/terraform-aws-k8s?ref=v0.19.2"
  name               = local.name
  region             = local.region
  dns_zone           = local.zone
  kubernetes_version = "1.21.5"
  master_count       = 3
  vpc_id             = module.k8s-network.vpc.id
  public_subnet_ids  = module.k8s-network.public_subnets
  iam_role_mappings  = {}
  bucket_state_store = module.state_store.bucket
  extra_addons       = module.k8s_monitoring.addons
}
