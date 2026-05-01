# yage-tofu

OpenTofu modules for [yage](https://github.com/lpasquali/yage) provider identity bootstrap.

Each subdirectory is a self-contained OpenTofu module that mints a scoped runtime credential for its cloud provider. yage clones this repo at a pinned tag and runs `tofu -chdir=<provider>/ apply` — no HCL is embedded in the yage binary.

## Modules

| Provider | Directory | Credential minted |
|---|---|---|
| AWS | `aws/` | IAM user + access key |
| Azure | `azure/` | Service Principal + client secret |
| GCP | `gcp/` | Service Account + JSON key |
| OpenStack | `openstack/` | Application Credential (Keystone) |
| OCI | `oci/` | API key pair |
| IBM Cloud | `ibmcloud/` | Service ID + API key |
| Linode | `linode/` | Personal Access Token (scoped) |
| Proxmox VE | `proxmox/` | PVE user + token (migrated from opentofux) |
| Registry (Phase H) | `registry/` | Proxmox VM running Harbor or Zot (ADR 0009) |

## Usage

yage calls these modules automatically when a provider has `TofuManaged=true` (env: `YAGE_<PROVIDER>_TOFU_MANAGED=true`). The pinned ref is controlled by `YAGE_TOFU_REF` (default: latest stable tag).

To run a module manually:

```bash
cd aws/
tofu init
tofu apply -var="region=us-east-1" -var="cluster_name=my-cluster"
tofu output -raw access_key_id
```

## Versioning

Modules are tagged with semver (`v0.1.0`, `v0.2.0`, …). yage pins to a specific tag via `YAGE_TOFU_REF`. Breaking changes bump the minor version until v1.0.0.

## Contributing

Each module must:
- Pin its upstream TF provider to a tested version in `required_providers`.
- Accept all credentials as input variables (no hardcoded values).
- Output exactly the keys that yage expects (documented per module in `outputs.tf`).
- Include a `README.md` describing required vars, outputs, and required IAM permissions.
