locals {
  project     = "cloudkit"
  environment = "dev"
  location    = "centralus"
  region_code = "central"  # Para nombres cortos como "east2", "central"

  # Ejemplo: vnet-cloudkit-dev-central
  resource_suffix = "${local.project}-${local.environment}-${local.region_code}"
}