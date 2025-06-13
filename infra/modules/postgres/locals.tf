# locals.tf (raíz del proyecto)

locals {
  project         = "cloudkit"
  environment     = "dev"
  region_code     = "central"
  location        = "centralus"
  resource_suffix = "${local.project}-${local.environment}-${local.region_code}"

  rg_name      = "rg-${local.resource_suffix}"
  cae_name     = "cae-${local.resource_suffix}"
}
