# SPDX-License-Identifier: Apache-2.0
# Copyright 2026 Luca Pasquali

terraform {
  backend "kubernetes" {
    secret_suffix = "gcp"
    namespace     = "yage-system"
    labels = {
      "app.kubernetes.io/managed-by" = "yage"
      "app.kubernetes.io/component"  = "tofu-state"
    }
  }
}
