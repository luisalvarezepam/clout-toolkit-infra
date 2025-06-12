
# CloudKit Terraform Infrastructure

This repository contains the modular Terraform code to deploy the full infrastructure for the CloudKit platform on Azure.

## 🔧 Modules Included

- **Network**: Virtual Network, private subnets, NAT Gateway
- **PostgreSQL**: Flexible Server with private integration, user and DB creation
- **Container Apps**: Flask backend running in a private subnet, ACR integration
- **Key Vault**: Secure storage of PostgreSQL passwords, integrated with Container Apps
- **Static Web Apps**: React frontend with CI/CD from GitHub and API proxy configuration

---

## 🚀 How to Use

### 1. Clone and navigate

```bash
git clone <your-repo-url>
cd cloudkit-terraform
```

### 2. Configure your `terraform.tfvars`

```hcl
rg_name           = "rg-cloudkit-dev-east2"
location          = "eastus2"
tenant_id         = "<your-azure-tenant-id>"
admin_object_id   = "<your-object-id-or-msi>"
pg_admin_user     = "pgadmin"
pg_admin_password = "secureAdminPassword123"
app_user          = "cloudkitapp"
app_password      = "secureAppPassword456"
repo_url          = "https://github.com/luisalvarezepam/KodeKloudEPAM"
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Plan and Apply

```bash
terraform plan
terraform apply
```

---

## 🔑 Key Vault Integration

The PostgreSQL admin and app passwords are securely stored in Azure Key Vault and referenced directly from Azure Container Apps using a User Assigned Managed Identity.

---

## 📦 Modules Folder

You can find each module under the `modules/` folder and reuse or expand them as needed.

---

## 📜 License

MIT
