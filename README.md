# terraform-aws-k8s-addons-grafana-agent-operator

A terraform module which provides the [custom addon](https://kops.sigs.k8s.io/addons/#custom-addons)
for [grafana-k8s-monitoring](https://github.com/grafana/k8s-monitoring-helm/) to be used together
with [opzkit/k8s/aws](https://registry.terraform.io/modules/opzkit/k8s/aws/latest).

# Credentials

Secrets must be created manually:

For metrics (prometheus):
```json
{
  "username": "122345",
  "password": "password",
  "hostname": "https://asd"
}
```

`username`, `password` and `hostname` can be overridden with the variables `metrics_<key>_key`

For logs (loki):
```json
{
  "username": "122345",
  "password": "password",
  "hostname": "https://asd"
}
```

`username`, `password` and `hostname` can be overridden with the variables `logs_<key>_key`

For traces (tempo):
```json
{
  "username": "122345",
  "password": "password",
  "hostname": "https://asd"
}
```

`username`, `password` and `hostname` can be overridden with the variables `traces_<key>_key`

## How to update the module to a new version of the operator

Update the chart-versions in grafana/kustomization.yaml and ksm/kustomization.yaml.
Also update versions in any custom-resources that are versioned (i.e. `monitoring.grafana.com/v1alpha1/GrafanaAgent`)
as well as the version in output.tf.

Remove any existing downloaded charts:

```shell
rm -rf grafana/charts
```

Run the kustomizations like below

```shell
kubectl kustomize . -o k8s-monitoring.yaml.tftpl --enable-helm
```

Check the changes and if everything looks correct, update version, commit, push and PR.
