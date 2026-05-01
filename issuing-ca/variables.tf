variable "cluster_name" {
  description = "Name of the yage workload cluster. Used as the CN suffix on the intermediate CA (yage-issuing-ca-<cluster_name>)."
  type        = string
}

variable "root_ca_cert" {
  description = "PEM-encoded root CA certificate supplied by the operator. Mirrors yage's cfg.IssuingCARootCert (env YAGE_ISSUING_CA_ROOT_CERT)."
  type        = string
  sensitive   = true
}

variable "root_ca_key" {
  description = "PEM-encoded root CA private key supplied by the operator. Mirrors yage's cfg.IssuingCARootKey (env YAGE_ISSUING_CA_ROOT_KEY). RSA, ECDSA, or Ed25519 accepted."
  type        = string
  sensitive   = true
}

variable "validity_hours" {
  description = "Validity period of the intermediate CA in hours. Default 8760h (365d), matching yage's issuingCAValidityDays."
  type        = number
  default     = 8760
}

variable "early_renewal_hours" {
  description = "Hours before expiry at which Tofu should regenerate the intermediate CA on the next apply. Default 720h (30d)."
  type        = number
  default     = 720
}
