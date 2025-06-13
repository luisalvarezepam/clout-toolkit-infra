module "storage_backend" {
  source                = "./modules/storage_backend"
  rg_name               = var.rg_name
  location              = var.location
  storage_account_name  = "cloudkitterraforcentr"  
}
