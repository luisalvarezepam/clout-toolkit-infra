locals {
  project         = "cloudkit"
  environment     = "dev"
  region_code     = "central"
  location        = "centralus"
  resource_suffix = "${local.project}-${local.environment}-${local.region_code}"
}
