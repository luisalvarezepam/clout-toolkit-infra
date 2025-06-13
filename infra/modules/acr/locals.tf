locals {
  project     = "cloudkit"
  environment = "dev"
  region_code = "central"
  resource_suffix = "${local.project}${local.environment}${local.region_code}"
}