locals {
  environment     = "dev"
  project         = "cloudkit"
  location_abbr   = "cus"
  name_suffix     = "${local.project}-${local.environment}-${local.location_abbr}"

  tags = {
    environment = local.environment
    project     = local.project
  }
}
