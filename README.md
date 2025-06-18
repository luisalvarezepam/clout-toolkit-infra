# ☁️ CloudKit Azure Infrastructure

This repository contains the Infrastructure as Code (IaC) definition using **Terraform** for the CloudKit solution on **Microsoft Azure**.

## ✅ Infrastructure Components (Provisioned)

| Component         | Azure Service                          | Description                                              |
|------------------|----------------------------------------|----------------------------------------------------------|
| Virtual Network  | Azure Virtual Network                  | Includes subnets for public, private, and database zones |
| Key Vault        | Azure Key Vault                        | Secure secrets and credentials                          |
| Container Registry | Azure Container Registry (ACR)       | Store private container images                           |
| PostgreSQL DB    | Azure Database for PostgreSQL Flexible | Managed database with VNet integration                   |
| Backend App      | Azure Container Apps                   | Runs backend image with private ACR and identity         |
| Worker App       | Azure Container Apps                   | Runs async tasks or scheduled jobs                       |
| Frontend         | Azure Web App for Containers           | Dockerized React/Vite frontend, served from Linux Plan   |
| Observability    | Azure Log Analytics + Diagnostics      | Logs and metrics for backend and worker apps             |
| Storage          | Azure Blob Storage                     | Stores reports, XLSX inputs, JSON outputs                |
| Networking       | NAT Gateway + NSG Rules                | Outbound internet and subnet isolation                   |

## 🔄 CI/CD Workflows

| Name                        | Type       | Description                               |
|-----------------------------|------------|-------------------------------------------|
| `terraform-deploy.yml`      | Push/manual | Provisions all infra using Terraform       |
| `deploy_container_app.yml`  | Manual     | Updates backend container app image        |
| `deploy_container_worker.yml` | Manual   | Updates worker container app image         |
| `deploy_webapp_frontend.yml` | Manual   | Updates frontend web app image             |

> All workflows use GitHub Actions with `AZURE_CREDENTIALS` secret configured.

## 📁 Repo Structure

```
.
├── infra/                     # Terraform code
│   ├── main.tf               # Root module
│   ├── modules/              # Modularized infra components
│   └── variables.tf / outputs.tf / ...
├── scripts/                  # Utility Python scripts (ignored via .gitignore)
├── .github/workflows/       # GitHub Actions pipelines
├── .gitignore               # Ignores Terraform files & scripts
└── README.md                # This file
```

## 🛡 Required GitHub Secrets

These secrets must be configured in the GitHub repository:

| Name                        | Description                          |
|-----------------------------|--------------------------------------|
| `AZURE_CREDENTIALS`         | JSON service principal credentials   |
| `ARM_CLIENT_ID`             | Azure Client ID                      |
| `ARM_CLIENT_SECRET`         | Azure Client Secret                  |
| `ARM_SUBSCRIPTION_ID`       | Subscription ID                      |
| `ARM_TENANT_ID`             | Tenant ID                            |
| `ADMIN_OBJECT_ID`           | Terraform admin's object ID          |
| `APP_REGISTRATION_OBJECT_ID` | App registration identity object ID |

## 🚀 Quick Start

1. Clone the repo and go into the `infra/` directory.
2. Ensure secrets are set in GitHub for workflows.
3. To deploy manually:
    ```bash
    cd infra
    terraform init
    terraform plan
    terraform apply
    ```
4. To deploy images:
    - Go to GitHub → Actions → Run `Deploy Container App`, `Deploy Container Worker`, or `Deploy Web App Frontend`.

---

## 🗺 Architecture Diagram

![Architecture](https://strepamkkeast2.blob.core.windows.net/kodekloud-inputs/ChatGPT%20Image%20Jun%2017%2C%202025%2C%2007_41_31%20PM.png?sp=r&st=2025-06-17T22:46:07Z&se=2026-02-28T07:04:40Z&sv=2024-11-04&sr=b&sig=8NO3nGnPEWJ3CvqKqDYGRU1dJ8Z8F3MSAfRMvPz7%2FhM%3D)

---

## 📌 Notes

- Terraform state is stored remotely using Azure Storage Account.
- Backends and container apps are deployed with system-assigned identity.
- Web app currently expects a prebuilt Docker image.
