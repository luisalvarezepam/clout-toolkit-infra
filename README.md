
# CloudKit – Azure Infrastructure

This repository contains the Terraform code to deploy the core infrastructure for **CloudKit** in Microsoft Azure.

![Architecture Diagram](https://cloudkitterraforcentr.blob.core.windows.net/images/ChatGPT%20Image%20Jun%2018%2C%202025%2C%2011_39_53%20AM.png?sp=r&st=2025-06-18T17:43:31Z&se=2026-03-01T01:43:31Z&sv=2024-11-04&sr=b&sig=ar3vocnoozDCKjJEL9dan5%2BbDKsLW9GPARVhHbk2H34%3D)

## 📦 Components Deployed

| Component         | Azure Service                        | Type              | Key Features                                       |
|------------------|--------------------------------------|-------------------|---------------------------------------------------|
| Frontend         | Azure Web App for Containers         | Web Hosting       | Private ACR image, HTTPS, Identity integration    |
| Backend API      | Azure Container Apps                 | Container PaaS    | Auto-scaling, VNET integration, Managed identity  |
| Worker           | Azure Container Apps                 | Background Tasks  | Private networking, ACR/Key Vault access          |
| Database         | Azure Database for PostgreSQL (Flex) | DBaaS             | HA, Backup, VNET integration                      |
| Network          | Azure Virtual Network (VNet)         | Network           | Subnets: public, private, db                      |
| Security         | Azure Key Vault                      | Secrets Management| Access via managed identities                     |
| Logging          | Azure Monitor + Log Analytics        | Observability     | Logs, metrics, diagnostic settings                |
| Container Images | Azure Container Registry (ACR)       | Registry          | Private secure container image storage            |
| Traffic Control  | Network Security Groups (NSGs)       | Networking        | Subnet-level traffic isolation                    |

> 🧾 **Note:** NAT Gateway was evaluated but omitted due to cost.

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/CloudLATAM/cloudkit-infra.git
cd cloudkit-infra
```

### 2. Configure Authentication

Set the following environment variables to allow Terraform to authenticate with Azure:

```bash
export ARM_CLIENT_ID="<your-client-id>"
export ARM_CLIENT_SECRET="<your-client-secret>"
export ARM_SUBSCRIPTION_ID="<your-subscription-id>"
export ARM_TENANT_ID="<your-tenant-id>"
```

### 3. Customize Your Variables

Edit `terraform.tfvars` or define environment-specific variables.

### 4. Initialize Terraform

```bash
terraform init
```

### 5. Review and Deploy

```bash
terraform plan
terraform apply
```

---

## 📁 Module Structure

| Module           | Purpose                                      |
|------------------|----------------------------------------------|
| `network`        | VNet and subnets                             |
| `key_vault`      | Key Vault and access policies                |
| `acr`            | Container registry                           |
| `container_apps` | Backend API container app                    |
| `container_worker` | Worker container app                      |
| `postgres`       | PostgreSQL Flexible Server                   |
| `diagnostic_setting` | Azure diagnostics for logs and metrics |
| `log_analytics`  | Log Analytics workspace                      |
| `web_app_frontend` | Frontend deployed as Azure Web App       |
| `network_security` | NSGs for subnet-level access control      |

---

## ✅ Current Status

- [x] Core networking and subnets created
- [x] Key Vault and secret access policies set
- [x] PostgreSQL Flexible Server deployed in private subnet
- [x] Container Apps (backend + worker) deployed
- [x] Web App for frontend deployed
- [x] Log Analytics and diagnostic settings configured
- [x] NSGs configured for subnet access control
- [x] NAT Gateway reviewed and omitted due to cost

---

## 📌 Next Steps

- Connect custom domain and SSL via Azure DNS (if required)
- Add autoscaling rules for backend/worker if usage grows
- Monitor with Azure Monitor and Application Insights
