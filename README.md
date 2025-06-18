# 🌩️ CloudKit Azure Infrastructure

This repository contains the infrastructure as code (IaC) for the **CloudKit** project, deployed on Microsoft Azure using Terraform and modular architecture.

---

## 🧱 Overall Architecture

![CloudKit Architecture](https://strepamkkeast2.blob.core.windows.net/kodekloud-inputs/CloudKit%20Azure%20Infra.png)

---

## ✅ Deployed Components

| Component         | Azure Service                         | Type            | Description                                         |
|------------------|----------------------------------------|------------------|-----------------------------------------------------|
| **Frontend**      | Azure Web App (Linux)                 | Web Hosting     | Deployed in App Service Plan (B1 tier)             |
| **Backend API**   | Azure Container Apps                  | Container PaaS  | Exposes API, integrated with ACR and Key Vault     |
| **Worker**        | Azure Container Apps                  | Background Job  | Executes asynchronous tasks                        |
| **Database**      | PostgreSQL Flexible Server            | DBaaS           | Private access from VNet                           |
| **Networking**    | Virtual Network with Subnets          | Networking      | Public, private, and DB subnets                    |
| **Secrets**       | Azure Key Vault                       | Security        | Secure secrets and connection strings              |
| **Registry**      | Azure Container Registry (ACR)        | Container Images| Stores private container images                    |
| **Monitoring**    | Log Analytics + Diagnostic Settings   | Observability   | Logs enabled for backend and worker apps           |

---

## 📂 Repository Structure

```
├── infra/                        # Terraform IaC code
│   ├── modules/
│   └── main.tf, outputs.tf, ...
├── backend/                      # Backend containerized app
│   ├── Dockerfile
│   └── app/
├── .github/workflows/           # CI/CD workflows
│   └── deploy-backend.yml
└── README.md
```

---

## ⚙️ Required Terraform Environment Variables

Before using `terraform`, configure the following:

```bash
export ARM_CLIENT_ID="<appId>"
export ARM_CLIENT_SECRET="<secret>"
export ARM_SUBSCRIPTION_ID="<subId>"
export ARM_TENANT_ID="<tenantId>"
```

---

## 🚀 Backend CI/CD - GitHub Actions

Automated deployment is handled via GitHub Actions. On push to `main`, the Docker image is built and deployed to Azure Container Apps.

### 🔐 Required GitHub Secrets:

- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`
- `ACR_LOGIN_SERVER`
- `RESOURCE_GROUP`
- `CONTAINER_APP_NAME`

Workflow path:  
📁 `.github/workflows/deploy-backend.yml`

---

## 🚧 Pending Tasks

| Task                                  | Status                |
|---------------------------------------|------------------------|
| CI/CD for Frontend and Worker         | 🔜 Waiting for code    |
| WAF or Load Balancer for ingress      | ⏳ Pending             |
| Refined NSG rules                     | ⏳ Pending             |
| Additional Storage for reports/files  | 🔜 Considered optional |
| Azure DNS                             | ❌ Skipped due to cost |

---

## 📞 Contact

For more information, contact the infrastructure architect or DevOps engineer of the project.