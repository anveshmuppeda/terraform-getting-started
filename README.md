# Terraform Getting Started

This repository demonstrates a step-by-step approach to learning Terraform, from basic concepts to advanced features like modules, remote execution, and workspaces.

---

## Structure

```
.
├── 001-simple-example
├── 002-var-example
├── 003-aws-provider
├── 004-ec2-app
├── 005-simple-module
├── 006-s3-backend
├── 007-remote-exec
├── 008-workspaces
└── README.md
```

---

## Guide

### 001-simple-example

- **Goal:** Introduce the basic Terraform syntax and workflow.
- **Files:** `main.tf`
- **How to use:**
  1. `cd 001-simple-example`
  2. `terraform init`
  3. `terraform apply`

---

### 002-var-example

- **Goal:** Demonstrate input variables.
- **Files:** `main.tf`, `variables.tf`
- **How to use:**
  1. `cd 002-var-example`
  2. Edit `variables.tf` to set variable defaults or use `-var` on the CLI.
  3. `terraform init`
  4. `terraform apply`

---

### 003-aws-provider

- **Goal:** Configure the AWS provider and use variables.
- **Files:** `main.tf`, `provider.tf`, `variables.tf`, `var.tfvars`
- **How to use:**
  1. `cd 003-aws-provider`
  2. Set your AWS credentials (via env vars or AWS CLI).
  3. `terraform init`
  4. `terraform apply -var-file=var.tfvars`

---

### 004-ec2-app

- **Goal:** Deploy a simple EC2 instance with user data.
- **Files:** `main.tf`, `provider.tf`, `variables.tf`, `terraform.tfvars`
- **How to use:**
  1. `cd 004-ec2-app`
  2. Update `terraform.tfvars` with your AMI ID and key pair.
  3. `terraform init`
  4. `terraform apply`

---

### 005-simple-module

- **Goal:** Introduce modules for reusable infrastructure.
- **Files:** `main.tf`, `modules/ec2-app/main.tf`, `modules/ec2-app/variables.tf`
- **How to use:**
  1. `cd 005-simple-module`
  2. `terraform init`
  3. `terraform apply`

---

### 006-s3-backend

- **Goal:** Use an S3 backend for remote state storage.
- **Files:** `backend.tf`, `main.tf`, `provider.tf`, `variables.tf`, `terraform.tfvars`
- **How to use:**
  1. `cd 006-s3-backend`
  2. Edit `backend.tf` with your S3 bucket details.
  3. `terraform init`
  4. `terraform apply`

---

### 007-remote-exec

- **Goal:** Use `remote-exec` and `file` provisioners to configure EC2 after launch.
- **Files:** `main.tf`, `index.html`, `modules/ec2-app/main.tf`, `modules/ec2-app/variables.tf`
- **How to use:**
  1. `cd 007-remote-exec`
  2. Update variables and `index.html` as needed.
  3. `terraform init`
  4. `terraform apply`

---

### 008-workspaces

- **Goal:** Manage multiple environments using workspaces and variable files.
- **Files:** `main.tf`, `variables.tf`, `dev.tfvars`, `staging.tfvars`, `prod.tfvars`, `modules/ec2-app/main.tf`, `modules/ec2-app/variables.tf`
- **How to use:**
  1. `cd 008-workspaces`
  2. Create/select a workspace:  
     `terraform workspace new dev`  
     `terraform workspace select dev`
  3. Apply with environment-specific variables:  
     `terraform apply -var-file=dev.tfvars`
  4. Repeat for `staging` and `prod` as needed.

---

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- AWS account and credentials configured (`aws configure` or environment variables)
- An existing AWS key pair for EC2 instances

---

## License

See [LICENSE](LICENSE) for details.

---

**Happy Terraforming!**
