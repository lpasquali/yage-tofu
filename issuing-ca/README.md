# issuing-ca

OpenTofu module that mints an online intermediate CA, signed by an
operator-supplied root, for cert-manager `ClusterIssuer` use on a yage workload
cluster (Phase H gap 2 / ADR 0009 §2).

Companion to yage's `internal/platform/opentofux.EnsureIssuingCA`
(yage PR [#163](https://github.com/lpasquali/yage/pull/163), commit `7b9d19b`).

## Status

The current `EnsureIssuingCA` Go implementation generates the intermediate CA
inline using `crypto/x509` and never invokes this module. This module exists to
land the OpenTofu shape so the Go side can be migrated to read its outputs in a
follow-up — issue [#4](https://github.com/lpasquali/yage-tofu/issues/4)
acceptance criteria.

## Inputs

| Variable | Required | Default | Description |
|---|---|---|---|
| `cluster_name` | yes | — | Workload cluster name; CN becomes `yage-issuing-ca-<cluster_name>`. |
| `root_ca_cert` | yes | — | PEM root CA cert (mirrors `cfg.IssuingCARootCert`). |
| `root_ca_key` | yes | — | PEM root CA key, RSA / ECDSA / Ed25519 (mirrors `cfg.IssuingCARootKey`). |
| `validity_hours` | no | `8760` | Validity in hours (default 365d, matches `issuingCAValidityDays`). |
| `early_renewal_hours` | no | `720` | Renewal threshold in hours (default 30d). |

## Outputs

| Output | Sensitive | Description |
|---|---|---|
| `intermediate_cert_pem` | no | Intermediate cert PEM (`tls.crt` in the cert-manager Secret). |
| `intermediate_key_pem` | yes | Intermediate key PEM, ECDSA P-256 (`tls.key`). |
| `ca_chain_pem` | no | Intermediate `||` root concatenation. |
| `root_ca_cert_pem` | no | Pass-through of the supplied root cert (`ca.crt` in the mgmt Secret). |

## Integration

When the orchestrator migrates `EnsureIssuingCA` to the JobRunner path:

1. yage clones `lpasquali/yage-tofu` at `cfg.TofuRef` into the `yage-repos`
   PVC (`EnsureRepoSync`, ADR 0010).
2. `JobRunner.Apply(cfg, "issuing-ca", vars)` runs `tofu apply` in-cluster,
   passing `cluster_name`, `root_ca_cert`, `root_ca_key` from `cfg`.
3. State is stored as Secret `tfstate-default-issuing-ca` in `yage-system`
   via the kubernetes backend declared in `backend.tf`.
4. `JobRunner.Output(cfg, "issuing-ca")` returns the four outputs above; the
   Go side patches `Secret yage-issuing-ca` (mgmt + workload `cert-manager`
   namespace) and applies `ClusterIssuer yage-ca-issuer`.

The root CA is operator-managed and cold (offline-root boundary per ADR 0009).
This module never generates the root.

## Running locally

```bash
cd issuing-ca/
tofu init -backend=false
tofu validate
tofu plan \
  -var="cluster_name=demo" \
  -var="root_ca_cert=$(cat root.crt)" \
  -var="root_ca_key=$(cat root.key)"
```

`-backend=false` skips the in-cluster kubernetes backend so the module is
runnable from a workstation. yage's JobRunner injects
`-backend-config=in_cluster_config=true` at `tofu init` time when running
in-cluster.
