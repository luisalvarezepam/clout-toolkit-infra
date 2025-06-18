
# CloudKit Azure Infrastructure

This repository contains the Terraform-based Infrastructure as Code (IaC) for the **CloudKit** project, deployed on Microsoft Azure.

## 📌 Architecture Overview

The infrastructure is designed with modularity, security, and scalability in mind. It includes components for backend processing, frontend delivery, observability, and secure networking.

![CloudKit Architecture](https://cloudkitterraforcentr.blob.core.windows.net/images/ChatGPT%20Image%20Jun%2018%2C%202025%2C%2011_39_53%20AM.png?sp=r&st=2025-06-18T17:43:31Z&se=2026-03-01T01:43:31Z&sv=2024-11-04&sr=b&sig=ar3vocnoozDCKjJEL9dan5%2BbDKsLW9GPARVhHbk2H34%3D)

---

## ✅ Provisioned Azure Components

| Component            | Azure Service                         | Purpose / Features                                                                 |
|---------------------|---------------------------------------|-------------------------------------------------------------------------------------|
| **Frontend**         | Azure Web App                         | Hosts the frontend container; deployed from GitHub Actions                          |
| **Backend**          | Azure Container Apps                  | Scalable API container hosted in private subnet                                     |
| **Worker**           | Azure Container Apps                  | Executes background jobs and automation logic                                       |
| **Database**         | Azure Database for PostgreSQL Flexible| Highly available relational database; VNet integrated                               |
| **Container Registry** | Azure Container Registry (ACR)     | Private registry for Docker images                                                  |
| **Secrets & Keys**   | Azure Key Vault                       | Secure storage for sensitive values like DB passwords and API keys                 |
| **Storage**          | Azure Blob Storage                    | For input Excel files and generated JSON reports                                    |
| **Networking**       | Azure Virtual Network (VNet)          | Includes public, private, and DB subnets                                            |
| **Security**         | NSG (Network Security Groups)         | Subnet-level access control                                                         |
| **Observability**    | Azure Monitor + Log Analytics         | Logs, metrics, and diagnostics for apps                                             |
| **CI/CD**            | GitHub Actions                        | Builds and deploys infra and application containers                                 |

---

## 🛠️ Getting Started

### Prerequisites

- Terraform ≥ 1.8
- Azure CLI
- Azure Subscription with permissions
- GitHub repository with the following secrets configured:

| Secret Name                    | Description                        |
|-------------------------------|------------------------------------|
| `ARM_CLIENT_ID`               | Client ID of the service principal |
| `ARM_CLIENT_SECRET`           | Client secret                      |
| `ARM_SUBSCRIPTION_ID`         | Azure subscription ID              |
| `ARM_TENANT_ID`               | Azure tenant ID                    |
| `ADMIN_OBJECT_ID`             | Object ID of the admin user        |
| `APP_REGISTRATION_OBJECT_ID` | Object ID of the App Registration  |

### Commands

```bash
cd infra
terraform init
terraform plan
terraform apply
```

---

## 📁 Project Structure

```
.
├── infra/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── modules/
│   │   ├── network/
│   │   ├── key_vault/
│   │   ├── acr/
│   │   ├── blob_storage/
│   │   ├── postgres/
│   │   ├── container_apps/
│   │   ├── container_worker/
│   │   ├── diagnostic_setting/
│   │   ├── log_analytics/
│   │   └── web_app_frontend/
├── .github/workflows/
│   └── ci-cd.yaml
├── .gitignore
└── README.md
```

---

## 🔄 Next Steps

- Add GitHub Actions pipeline for `web_app_frontend` and `container_worker`
- Optional: Configure custom domain and Azure DNS
- Optional: Add NAT Gateway if outbound static IP is needed

---

## 🧾 License

MIT License
