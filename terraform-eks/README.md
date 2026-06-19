# Production EKS Terraform Project

This repository contains a complete, production-ready Infrastructure-as-Code (IaC) configuration using Terraform to provision and manage a highly available, secure Amazon Elastic Kubernetes Service (EKS) environment on AWS, following the AWS Well-Architected Framework.

## Architecture Overview

The configuration provisions the following AWS components:
- **VPC Networking**: A custom VPC with a `/16` CIDR, public/private subnets across multiple Availability Zones, DNS support/hostnames, an Internet Gateway, one NAT Gateway, Route Tables, and appropriate Kubernetes discovery tags (`kubernetes.io/role/elb`, `kubernetes.io/role/internal-elb`, `kubernetes.io/cluster/<cluster-name>`).
- **Control Plane**: An Amazon EKS cluster with KMS-encrypted secrets at rest, control plane logging active (API, Audit, Authenticator, Controller Manager, Scheduler), and public/private endpoint access enabled.
- **Worker Nodes**: A Managed Node Group with EC2 Launch Templates specifying 50GB gp3 EBS storage, dynamic Autoscaling (Desired: 2, Min: 2, Max: 5), and standard IAM role configuration.
- **Addons & Helm Charts**: Managed plugins for CoreDNS, kube-proxy, VPC CNI, and AWS EBS CSI Driver (with IRSA configuration), plus the Kubernetes Metrics Server deployed via Helm.
- **Security & IAM**: Custom IAM roles following the principle of least privilege, OIDC provider creation, and IAM Roles for Service Accounts (IRSA) support.
- **Remote State Backend**: An S3 bucket and DynamoDB locking table to safely manage and share Terraform state across multiple users.

---

## Directory Structure

```text
terraform-eks/
├── bootstrap/              # Bootstrap module to create S3 bucket and DynamoDB table
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── main.tf                 # Module orchestrator
├── variables.tf            # Global input variables
├── outputs.tf              # Core infrastructure outputs
├── providers.tf            # AWS, Kubernetes, Helm, TLS & Time providers
├── versions.tf             # Enforced provider & Terraform versions (with S3 backend configured)
├── locals.tf               # Tag combinations and global local parameters
├── terraform.tfvars.example # Template config variables
├── README.md               # Setup and verification instructions
└── modules/
    ├── vpc/                # Custom VPC, Subnets, Gateways, Route Tables
    ├── iam/                # EKS, Node, EBS CSI, and Application IAM roles
    ├── eks/                # KMS keys, Security Groups, Cluster & Node Groups
    └── addons/             # Managed Addons and Helm charts (Metrics Server)
```

---

## 1. Prerequisites

Before deployment, ensure you have the following installed on your machine:
- [Terraform](https://developer.hashicorp.com/terraform/downloads) (>= 1.8.0)
- [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) (configured with admin/power-user credentials)
- [kubectl](https://kubernetes.io/docs/tasks/tools/) (compatible with Kubernetes version 1.30)
- [Helm v3](https://helm.sh/docs/intro/install/) (if deploying manual charts)

---

## 2. Authentication

Before running Terraform, authenticate your CLI against the target AWS Account using one of the following:

### Option A: Standard Profile
Run the configure command and input your Access Key, Secret Key, default region (`us-east-1`), and output format:
```bash
aws configure
```

### Option B: AWS SSO / IAM Identity Center
If your organization uses AWS SSO, run:
```bash
aws sso login
```
Then export your profile name:
```bash
export AWS_PROFILE=your-sso-profile
# Or in PowerShell:
$env:AWS_PROFILE="your-sso-profile"
```

Verify your authentication details:
```bash
aws sts get-caller-identity
```

---

## 3. Deployment Steps

### Step 0: Bootstrap the S3 Backend
Before you can run the main configuration, you must provision the S3 bucket and DynamoDB locking table that will host the Terraform state.
1. Navigate to the bootstrap directory:
   ```bash
   cd bootstrap
   ```
2. Initialize and deploy:
   ```bash
   terraform init
   ```
   ```bash
   terraform apply
   ```
   *Confirm with `yes`*. This will output the name of the S3 bucket and DynamoDB table.
3. Return to the root folder:
   ```bash
   cd ..
   ```

### Step 1: Copy Configuration File
Duplicate the template configuration and customize if needed:
```bash
cp terraform.tfvars.example terraform.tfvars
```

### Step 2: Initialize the Root Config (and Migrate State)
Initialize the project. Because the `versions.tf` contains the active S3 backend block, this will automatically prompt you to migrate your local state (or store the new state) inside the newly bootstrapped S3 bucket:
```bash
terraform init
```

### Step 3: Preview the Plan
Execute a dry run to verify the resources that will be provisioned (should output `~33` resources):
```bash
terraform plan
```

### Step 4: Apply Changes
Provision the AWS infrastructure:
```bash
terraform apply
```
Enter `yes` when prompted.

---

## 4. Verification

After a successful deployment, retrieve the EKS configuration and inspect the cluster state.

### Step 1: Update local Kubeconfig
Connect your local `kubectl` context to the newly created EKS cluster:
```bash
aws eks update-kubeconfig --region us-east-1 --name eks-prod
```

### Step 2: Verify Nodes
Verify that the worker nodes are in a `Ready` status:
```bash
kubectl get nodes
```

### Step 3: Check System Pods
Confirm all CoreDNS, VPC CNI, EBS CSI Driver, and Metrics Server pods are running:
```bash
kubectl get pods -n kube-system
```

### Step 4: Verify Metrics Server
Ensure CPU/Memory metrics are correctly fetched:
```bash
kubectl top nodes
```

---

## 5. Clean Up (Destroy)

To completely clean up and delete all resources (including the state S3 bucket), follow this exact order:

### Step 1: Destroy EKS Cluster Infrastructure
Run destroy inside the root directory to delete EKS, VPC, nodes, and IAM roles:
```bash
terraform destroy
```
*Wait for this run to finish completely (takes ~15 minutes).* EKS cluster and active resources are now deleted, and the state file is cleaned.

### Step 2: Destroy Backend S3 Bucket and DynamoDB Lock Table
Finally, navigate to the bootstrap directory to delete the state storage and lock resources:
```bash
cd bootstrap
terraform destroy
```
*Confirm with `yes`*. All resources (including the backend storage) have now been fully removed from AWS, leaving no orphaned resources.

