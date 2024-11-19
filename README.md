# terraform-aws-k8s-addons-grafana-agent-operator

A terraform module which provides the [custom addon](https://kops.sigs.k8s.io/addons/#custom-addons)
for [grafana-k8s-monitoring](https://github.com/grafana/k8s-monitoring-helm/) to be used together
with [opzkit/k8s/aws](https://registry.terraform.io/modules/opzkit/k8s/aws/latest).

# Credentials

Secrets must be created manually and contain the following information

For metrics:

Secret name: `prometheus`
```json
{
  "username": "122345",
  "password": "password",
  "hostname": "https://prometheus-prod-01-eu-west-0.grafana.net",
  "hostname_prom": "https://prometheus-prod-01-eu-west-0.grafana.net/api/prom"
}
```

`username`, `password` and `hostname` can be overridden with the variables `metrics_<key>_key`

For logs (loki):

Secret name: `loki`
```json
{
  "username": "122345",
  "password": "password",
  "hostname": "https://logs-prod-eu-west-0.grafana.net"
}
```

`username`, `password` and `hostname` can be overridden with the variables `logs_<key>_key`

For traces (tempo):

Secret name: `tempo`
```json
{
  "username": "122345",
  "password": "password",
  "hostname": "https://tempo-eu-west-0.grafana.net:443"
}
```

`username`, `password` and `hostname` can be overridden with the variables `traces_<key>_key`

The name of the secrets can be overridden with the `<type>_secret` variable.

## How to update the module to a new version of the operator

Update the chart-versions in grafana/kustomization.yaml.
Also update versions output.tf.

Remove any existing downloaded charts:

```shell
rm -rf grafana/charts
```

Run the kustomizations like below

```shell
kubectl kustomize . -o k8s-monitoring.yaml.tftpl --enable-helm
```

Check the changes and if everything looks correct, update version, commit, push and PR.
