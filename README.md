# Argo CD Deployment on Amazon EKS using Terraform

## 📌 Project Overview

This project demonstrates how to provision an Amazon EKS cluster using Terraform and implement GitOps with Argo CD. The infrastructure is created on AWS, Argo CD is installed using the Helm provider, and application deployments are managed automatically from a GitHub repository.

The project follows Infrastructure as Code (IaC) and GitOps best practices by separating infrastructure provisioning from application deployment.

---

## 🏗️ Architecture

```
Developer
    │
    │ Push Code
    ▼
GitHub Repository
    │
    │ Watches Repository
    ▼
Argo CD
    │
    │ Syncs Kubernetes Manifests
    ▼
Amazon EKS Cluster
    │
    ├── Deployment
    ├── Service (LoadBalancer)
    └── Pods
```

Infrastructure provisioning flow:

```
Terraform
    │
    ├── Creates IAM Roles
    ├── Creates EKS Cluster
    ├── Creates Node Group
    ├── Installs Argo CD using Helm
    └── Creates Argo CD Application
```

---

## 🚀 Technologies Used

* Terraform
* Amazon Web Services (AWS)
* Amazon EKS
* Kubernetes
* Argo CD
* Helm
* Git
* GitHub
* Docker
* AWS CLI
* kubectl

---

## 📂 Project Structure

```
ArgoCD-Deployment/
│
├── infrastructure/
│   ├── main.tf
│   ├── helm.tf
│   ├── argocd.tf
│   ├── application.tf
│   ├── permission.tf
│   ├── output.tf
│   └── loadbalancer.tf
│
├── manifest/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   └── application.yaml
│
├── README.md
```

---

## ⚙️ Infrastructure Components

Terraform provisions:

* Amazon VPC
* Public Subnets
* Internet Gateway
* Route Tables
* IAM Roles
* Amazon EKS Cluster
* Managed Node Group
* EKS Access Entry
* Argo CD Namespace
* Argo CD Installation using Helm
* Argo CD Application

---

## 📦 Application Deployment

The sample application is deployed using Argo CD.

Deployment includes:

* Kubernetes Deployment
* Kubernetes Service (LoadBalancer)

Docker Image:

```
dipanshubisen/static-website:latest
```

---

## 🔄 GitOps Workflow

1. Developer pushes Kubernetes manifest changes to GitHub.
2. Argo CD continuously monitors the repository.
3. Argo CD detects changes.
4. Argo CD synchronizes the cluster automatically.
5. Kubernetes updates the running application.

No manual `kubectl apply` is required after Argo CD is configured.

---

## ▶️ Deployment Steps

### Clone the Repository

```bash
git clone <repository-url>
cd ArgoCD-Deployment
```

### Initialize Terraform

```bash
cd infrastructure

terraform init
```

### Validate Configuration

```bash
terraform validate
```

### Review Execution Plan

```bash
terraform plan
```

### Create Infrastructure

```bash
terraform apply
```

---

## Configure kubectl

```bash
aws eks update-kubeconfig \
--region ap-south-1 \
--name my-cluster
```

Verify the cluster:

```bash
kubectl get nodes
```

---

## Access Argo CD

Terraform outputs:

* Argo CD URL
* Username
* Password (sensitive output)

Retrieve the password:

```bash
terraform output -raw argocd_admin_password
```

Default username:

```
admin
```

---

## Verify Deployment

Check nodes:

```bash
kubectl get nodes
```

Check Argo CD Application:

```bash
kubectl get applications -n argocd
```

Check pods:

```bash
kubectl get pods -A
```

Check services:

```bash
kubectl get svc -A
```

---

## Features

* Infrastructure as Code using Terraform
* Automated EKS provisioning
* Helm-based Argo CD installation
* GitOps continuous deployment
* Automatic synchronization
* Self-healing deployments
* Automatic pruning of removed resources
* Kubernetes LoadBalancer service
* Secure IAM-based authentication

---

## Learning Outcomes

This project demonstrates practical experience with:

* Terraform modules and providers
* AWS networking
* Amazon EKS
* Kubernetes fundamentals
* Helm package management
* Argo CD GitOps workflows
* Continuous Deployment
* Infrastructure automation
* AWS IAM
* Kubernetes Services and Deployments

---

## Future Improvements

* HTTPS using AWS Load Balancer Controller
* ExternalDNS integration
* Monitoring with Prometheus and Grafana
* Logging with EFK or Loki
* GitHub Actions CI/CD pipeline
* Multi-environment deployments (Dev, UAT, Prod)
* Terraform remote state using Amazon S3 and DynamoDB
* Secrets management using AWS Secrets Manager or HashiCorp Vault

---

## Cleanup

Destroy all resources:

```bash
terraform destroy
```

---

## Author

**Dipanshu Bisen**

DevOps | Cloud | Kubernetes | Terraform | AWS
