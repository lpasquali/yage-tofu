output "intermediate_cert_pem" {
  description = "PEM-encoded intermediate CA certificate. Lands in the cert-manager Secret as tls.crt."
  value       = tls_locally_signed_cert.intermediate.cert_pem
}

output "intermediate_key_pem" {
  description = "PEM-encoded intermediate CA private key (ECDSA P-256). Lands in the cert-manager Secret as tls.key."
  value       = tls_private_key.intermediate.private_key_pem
  sensitive   = true
}

output "ca_chain_pem" {
  description = "Intermediate || root concatenation, suitable for clients that want the full chain. The intermediate is first, root last. Marked sensitive because it embeds the operator-supplied root cert variable."
  value       = "${tls_locally_signed_cert.intermediate.cert_pem}${var.root_ca_cert}"
  sensitive   = true
}

output "root_ca_cert_pem" {
  description = "Pass-through of the operator-supplied root CA cert. Lands in the management-cluster Secret as ca.crt (mirrors yage's EnsureIssuingCA Secret data). Marked sensitive only because the input var is."
  value       = var.root_ca_cert
  sensitive   = true
}
