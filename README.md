# ExpenseFlow — Azure DevOps + AKS End-to-End Project

A production-grade expense management platform built to demonstrate a full DevOps lifecycle on Azure, infrastructure provisioning with Terraform to containerised application deployment on AKS, complete with CI/CD pipelines and Prometheus/Grafana observability.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Repository Structure](#repository-structure)
- [Tech Stack](#tech-stack)
- [Infrastructure](#infrastructure)
- [Application](#application)
- [CI/CD Pipelines](#cicd-pipelines)
- [Monitoring & Observability](#monitoring--observability)
- [Getting Started](#getting-started)

---

## Project Overview

ExpenseFlow is a multi-tier expense tracking and approval system with:

- **Role-based access** — employees submit expenses; managers approve or reject them
- **Analytics dashboard** — spend trends, category breakdowns, budget utilisation
- **Receipt uploads** — files stored in Azure Blob Storage
- **Real-time notifications** — Redis-backed notification service
- **Health monitoring** — `/health` endpoint checks database, Redis, and blob storage

The project is intentionally designed to mirror real-world enterprise setups: separate dev and prod environments, remote Terraform state, environment-gated deployments, and GitOps-style Helm releases.

---

## Architecture

```
                         ┌─────────────────────────────────────┐
                         │           Azure DevOps               │
                         │  CI Pipeline → CD Dev → CD Prod      │
                         └──────────────┬──────────────────────┘
                                        │
              ┌─────────────────────────▼──────────────────────────┐
              │                    Azure Cloud                      │
              │                                                     │
              │   ACR (dev)          ACR (prod)                     │
              │      │                   │                          │
              │   ┌──▼───────────────────▼──┐                       │
              │   │     AKS Cluster (dev/prod)                      │
              │   │  ┌────────────────────┐  │                      │
              │   │  │  expenseflow-dev/  │  │                      │
              │   │  │  prod namespace    │  │                      │
              │   │  │  ┌──────────────┐  │  │                      │
              │   │  │  │   Frontend   │  │  │                      │
              │   │  │  │  (Next.js)   │  │  │                      │
              │   │  │  └──────┬───────┘  │  │                      │
              │   │  │         │ /api     │  │                      │
              │   │  │  ┌──────▼───────┐  │  │                      │
              │   │  │  │   Backend    │  │  │                      │
              │   │  │  │  (FastAPI)   │  │  │                      │
              │   │  │  └──────┬───────┘  │  │                      │
              │   │  └─────────┼──────────┘  │                      │
              │   └───────────┬┼─────────────┘                      │
              │               ││                                    │
              │    ┌──────────┘└────────────┐                       │
              │    │                        │                       │
              │  PostgreSQL            Azure Cache                  │
              │  Flexible Server       for Redis                    │
              │  (private subnet)                                   │
              │                                                     │
              │  Azure Blob Storage    Azure Key Vault              │
              │  (receipt uploads)     (secrets)                    │
              │                                                     │
              │  Log Analytics         Prometheus + Grafana         │
              │  Workspace             (kube-prometheus-stack)      │
              └─────────────────────────────────────────────────────┘
```

---

## Repository Structure

```
.
├── .azuredevops/
│   └── pipelines/
│       ├── app/
│       │   ├── ci.yml             # Build & push Docker images to ACR (dev + prod)
│       │   ├── cd-dev.yml         # Helm deploy to dev AKS
│       │   └── cd-prod.yml        # Helm deploy to prod AKS
│       ├── infra/
│       │   ├── bootstrap.yml      # One-time Terraform remote state setup
│       │   ├── validate.yml       # Terraform + Helm + monitoring manifest validation on PRs
│       │   ├── dev.yml            # Plan + apply dev infrastructure
│       │   ├── prod.yml           # Plan + apply prod infrastructure
│       │   └── destroy.yml        # Tear-down pipeline (prod → dev → bootstrap)
│       └── monitoring/
│           └── deploy.yml         # Deploy kube-prometheus-stack + dashboards (dev → prod)
│
├── expense-infra/
│   ├── bootstrap/                 # Remote state storage (Azure Storage)
│   ├── modules/                   # Reusable Terraform module
│   │   ├── aks.tf                 # AKS cluster + ACR pull role
│   │   ├── network.tf             # VNet, subnets, private DNS
│   │   ├── database.tf            # PostgreSQL Flexible Server
│   │   ├── cache.tf               # Azure Cache for Redis
│   │   ├── storage.tf             # Blob Storage + receipts container
│   │   ├── acr.tf                 # Azure Container Registry
│   │   ├── security.tf            # Key Vault + RBAC
│   │   └── observability.tf       # Log Analytics Workspace
│   └── envs/
│       ├── dev/                   # Dev environment tfvars + backend
│       └── prod/                  # Prod environment tfvars + backend
│
├── expense-app/
│   ├── backend/                   # FastAPI application (Python)
│   │   ├── app/
│   │   │   ├── api/               # Route handlers (auth, expenses, budgets, analytics, …)
│   │   │   ├── models/            # SQLAlchemy ORM entities
│   │   │   ├── schemas/           # Pydantic DTOs
│   │   │   ├── services/          # Cache, storage, notifications, reports
│   │   │   └── core/              # Config, database, security, dependencies
│   │   ├── Dockerfile
│   │   └── requirements.txt
│   └── frontend/                  # Next.js 15 application (TypeScript)
│       ├── app/                   # App Router pages (dashboard, login, team)
│       ├── components/            # Charts, tables, stat cards, shell
│       ├── lib/                   # API client, auth helpers, types
│       └── Dockerfile
│
├── expense-deploy/
│   └── helm/expenseflow/          # Helm chart for the full application
│       ├── templates/             # Deployment, Service, Ingress, ConfigMap, Secret
│       ├── values.yaml            # Base values
│       ├── values-dev.yaml        # Dev overrides
│       └── values-prod.yaml       # Prod overrides
│
└── expense-monitoring/
    ├── kube-prometheus-stack-values.yaml   # Helm values for kube-prometheus-stack
    ├── expense-app-servicemonitor.yaml     # Prometheus ServiceMonitor
    ├── grafana-dashboard-configmap.yaml    # Auto-provisioned Grafana dashboard
    └── grafana-ingress.yaml               # Ingress for Grafana UI
```

---

## Tech Stack

| Layer | Technology |
|---|---|
| Cloud | Microsoft Azure |
| Infrastructure as Code | Terraform (azurerm provider v3) |
| Container Orchestration | Azure Kubernetes Service (AKS) |
| Container Registry | Azure Container Registry (ACR) |
| CI/CD | Azure DevOps Pipelines |
| Package Management (K8s) | Helm |
| Backend | Python 3, FastAPI, SQLAlchemy (async), Uvicorn |
| Frontend | Next.js 15, React 19, TypeScript |
| Database | Azure Database for PostgreSQL Flexible Server v16 |
| Cache | Azure Cache for Redis v6 |
| Object Storage | Azure Blob Storage |
| Secrets Management | Azure Key Vault |
| Monitoring | kube-prometheus-stack (Prometheus + Grafana) |
| Log Management | Azure Log Analytics Workspace |
| Ingress | NGINX Ingress Controller |
| Identity | AKS Workload Identity + OIDC Issuer |

---

## Infrastructure

Infrastructure is managed entirely with Terraform and follows an environment-per-folder pattern with a shared reusable module.

### Bootstrap

Before any environment can be provisioned, a one-time bootstrap pipeline creates the Azure Storage Account used for Terraform remote state. This is handled by `expense-infra/bootstrap/` and the `bootstrap.yml` pipeline.

### Module Resources

The shared Terraform module provisions the following resources for each environment:

- **Resource Group** — scoped per environment
- **Virtual Network** — dedicated VNet with separate subnets for AKS nodes and the database
- **AKS Cluster** — Standard tier, VirtualMachineScaleSets node pool, Azure CNI networking, RBAC, Workload Identity, OIDC issuer, OMS agent connected to Log Analytics
- **Azure Container Registry** — admin access disabled; AKS kubelet identity assigned AcrPull role
- **PostgreSQL Flexible Server** — v16, deployed into a private subnet with a private DNS zone (no public network access)
- **Azure Cache for Redis** — v6, TLS 1.2 minimum, SSL-only
- **Azure Blob Storage** — versioning enabled, private receipts container
- **Azure Key Vault** — RBAC-authorised, purge protection enabled
- **Log Analytics Workspace** — AKS diagnostic logs sink

### Environments

| Environment | State Backend | Approval Gate |
|---|---|---|
| dev | Azure Storage (dev container) | Automatic on merge to `main` |
| prod | Azure Storage (prod container) | Manual approval via Azure DevOps environment |

---

## Application

### Backend (FastAPI)

Located in `expense-app/backend/`. Key capabilities:

- **JWT authentication** — login, token validation, role-based route guards
- **Expense management** — CRUD, approval/rejection workflow, receipt file uploads
- **Budgets** — per-category monthly budget tracking
- **Analytics** — spend trends, category breakdowns, budget performance
- **Notifications** — activity feed for expense events
- **Reports** — team spend summaries
- **Health endpoint** — `/health` checks PostgreSQL, Redis, and Azure Blob Storage connectivity
- **Security headers** middleware — `X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy`, `Permissions-Policy`

### Frontend (Next.js 15)

Located in `expense-app/frontend/`. Key pages and components:

- **Login page** — JWT-based authentication flow
- **Dashboard** — analytics overview, spend trend chart, category donut, budget bars, expense table with inline approve/reject, quick-add form, notification feed
- **Team page** — team spending report
- All API calls proxied through `/api` to avoid CORS issues in production

### Helm Chart

The `expense-deploy/helm/expenseflow` chart packages both frontend and backend into a single deployable unit with:

- Separate `Deployment` and `Service` for backend and frontend
- `ConfigMap` for non-sensitive environment variables
- `Secret` for sensitive values (JWT secret, database URL, Redis URL, blob connection string) injected at deploy time
- `Ingress` with NGINX class, optional TLS

---

## CI/CD Pipelines

All pipelines run on a self-hosted Azure DevOps agent (`devops-self-hosted-agent`).

### Infrastructure Pipelines

| Pipeline | Trigger | What it does |
|---|---|---|
| `infra/validate.yml` | PR to `main` (infra / deploy / monitoring paths) | Parallel jobs: Terraform validate (bootstrap, dev, prod) + Helm lint/template + `kubectl --dry-run` on monitoring manifests |
| `infra/bootstrap.yml` | Merge to `main` (bootstrap paths) | Init → validate → plan → apply Terraform remote state backend |
| `infra/dev.yml` | Merge to `main` (dev infra paths) | Plan → publish tfplan artifact → apply dev (environment gate) |
| `infra/prod.yml` | Manual dispatch | Plan → publish tfplan artifact → apply prod (manual approval gate) |
| `infra/destroy.yml` | Manual | Tears down prod → dev → bootstrap in sequence, each with an environment gate |

### Application Pipelines

| Pipeline | Trigger | What it does |
|---|---|---|
| `app/ci.yml` | Merge/PR to `main` (app paths) | Validate stage (Helm lint) → parallel build jobs (backend + frontend) for both dev and prod ACR → publish image tag artifact |
| `app/cd-dev.yml` | Manual dispatch | Get AKS credentials → `helm upgrade --install` to dev namespace → verify rollout |
| `app/cd-prod.yml` | Manual dispatch | Get AKS credentials → `helm upgrade --install` to prod namespace (manual approval gate) → verify rollout |

### Monitoring Pipeline

| Pipeline | Trigger | What it does |
|---|---|---|
| `monitoring/deploy.yml` | Merge to `main` (`expense-monitoring/**`) | Deploy kube-prometheus-stack via Helm → apply ServiceMonitor + Grafana dashboard ConfigMap + Grafana Ingress → verify pods; runs dev first, then prod with manual approval gate |

Sensitive values (database URL, Redis URL, JWT secret, blob connection string) are stored in Azure DevOps variable groups (`expenseflow-app-dev`, `expenseflow-app-prod`) and injected as Helm set-string arguments at deploy time — never committed to source control.

---

## Monitoring & Observability

Monitoring is deployed using the `kube-prometheus-stack` Helm chart into the `monitoring` namespace.

### Prometheus

A `ServiceMonitor` (`expense-monitoring/expense-app-servicemonitor.yaml`) targets pods labelled `app: expense-app` in the `production` namespace, scraping `/metrics` every 15 seconds.

### Grafana Dashboard

An auto-provisioned Grafana dashboard (`grafana-dashboard-configmap.yaml`) provides:

| Panel | Query |
|---|---|
| Total Requests | `sum(http_requests_total)` |
| Request Rate | `sum(rate(http_requests_total[5m]))` |
| Average Response Time | P50 latency from `http_request_duration_seconds` |
| Deployment Replicas | `kube_deployment_status_replicas` |
| Requests by Route | Per-route breakdown |
| Pod CPU Usage | `container_cpu_usage_seconds_total` per pod |
| Pod Memory Usage | `container_memory_working_set_bytes` per pod |

### Azure Log Analytics

AKS diagnostic logs and container insights are streamed to an Azure Log Analytics Workspace, provisioned as part of the Terraform module.

---

## Getting Started

### Prerequisites

- Azure subscription with Owner/Contributor access
- Azure DevOps organisation and project
- Self-hosted Azure DevOps agent with: `az cli`, `terraform`, `helm`, `kubectl`
- Service connection `sc-expenseflow-azure` configured in Azure DevOps

### 1 — Bootstrap Remote State

Run the `bootstrap.yml` pipeline once. This creates the Azure Storage Account and container used by all subsequent Terraform operations.

### 2 — Provision Infrastructure

Merge changes under `expense-infra/envs/dev/` to trigger `infra-dev.yml`. The pipeline will plan, publish the plan as an artifact, then apply after environment approval.

Repeat with `infra-prod.yml` for the prod environment.

### 3 — Configure Variable Groups

In Azure DevOps, create variable groups `expenseflow-app-dev` and `expenseflow-app-prod` containing:

| Variable | Description |
|---|---|
| `aks_resource_group` | Resource group name of the AKS cluster |
| `aks_cluster_name` | AKS cluster name |
| `jwt_secret` | JWT signing secret |
| `database_url` | PostgreSQL connection string |
| `redis_url` | Redis connection string |
| `azure_blob_connection_string` | Azure Storage connection string |

### 4 — Build and Deploy the Application

Merge changes under `expense-app/` or `expense-deploy/` to trigger `app-ci.yml`. Once images are built and pushed to ACR, manually trigger `app-cd-dev.yml` (or `app-cd-prod.yml`) with the image tag output from CI.

### 5 — Deploy Monitoring

Merge any change under `expense-monitoring/` to trigger the `monitoring/deploy.yml` pipeline automatically. It will deploy the kube-prometheus-stack Helm chart and apply all monitoring manifests to dev first, then prod after manual approval.

Alternatively, run manually via Azure DevOps → Pipelines → **monitoring/deploy**.
