
# CloudKit Azure Infrastructure

This repository contains the Terraform configuration for deploying the full CloudKit platform on Azure. It includes network, backend, frontend, database, container registry, security, and CI/CD infrastructure components.

## 📐 Architecture Diagram

![CloudKit Azure Infra](https://strepamkkeast2.blob.core.windows.net/kodekloud-inputs/cloudkit-terraform-diagram-v2.png)

## 🚀 Modules Overview

| Component          | Azure Service                           | Type            | Key Features                                               |
|-------------------|------------------------------------------|------------------|------------------------------------------------------------|
| **Frontend**       | Azure Static Web Apps                   | Serverless       | GitHub integration, HTTPS, CDN, custom domain              |
| **Backend**        | Azure Container Apps                    | PaaS             | Flask API, VNet-injected, secure, no public ingress        |
| **Database**       | PostgreSQL Flexible Server              | DBaaS            | VNet integration, high availability, backup                |
| **Network**        | Azure Virtual Network                   | Network          | Isolated subnets, NAT Gateway, DNS                         |
| **Security**       | Azure Key Vault                         | Secret Manager   | Stores DB passwords, accessed via managed identity         |
| **Container Registry** | Azure Container Registry            | Container Registry | Secure private image hosting                               |
| **CI/CD**          | GitHub Actions via Static Web Integration | CI/CD Automation | Builds and deploys frontend on commits                     |
| **Remote State**   | Azure Storage Account                   | Terraform Backend | Stores tfstate securely and remotely                       |

## 📦 Terraform Structure

```bash
.
├── main.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── modules/
│   ├── network/
│   ├── postgres/
│   ├── key_vault/
│   ├── acr/
│   ├── container_env/
│   ├── container_apps/
│   └── static_web/
```

## 📄 Usage

```bash
terraform init
terraform plan
terraform apply
```

## 🛡️ Requirements

- Terraform >= 1.3.0
- Azure CLI authenticated
- GitHub Personal Access Token for deployment

