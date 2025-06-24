# Terraform Getting Started

This repository demonstrates a step-by-step approach to learning Terraform, from basic concepts to advanced features like modules, remote execution, workspaces, and AWS Secrets Manager integration.

---

## Getting Started

1. **Clone this repository:**
   ```sh
   git clone https://github.com/anveshmuppeda/terraform-getting-started.git
   cd terraform-getting-started
   ```

2. **Follow the section guides below for each example.**

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
├── 009-awssm-secret
├── 010-rds-awssm
├── 011-rds-awssm-advanced
├── 012-import-example
├── 013-refresh-example
├── 014-eks-cluster
├── 015-eks-awsmodules
├── 016-functions
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

### 009-awssm-secret

- **Goal:** Use AWS Secrets Manager to inject secrets into your Terraform-managed infrastructure.
- **Files:** `main.tf`, `variables.tf`, `terraform.tfvars`, `modules/ec2-app/main.tf`, `modules/ec2-app/variables.tf`
- **How to use:**
  1. `cd 009-awssm-secret`
  2. Ensure you have a secret named `terraform-demo-secret` in AWS Secrets Manager with a JSON structure (e.g., `{"username": "myappuser"}`).
  3. Update `terraform.tfvars` with your AMI ID, instance type, and other variables as needed.
  4. `terraform init`
  5. `terraform apply`
  6. The EC2 instance will use the secret value (e.g., `username`) as the instance name.

---

### 010-rds-awssm

- **Goal:** Provision an AWS RDS MySQL instance with credentials managed in AWS Secrets Manager using Terraform modules.
- **Files:** 
  - `main.tf`
  - `provider.tf`
  - `modules/secretmanager/main.tf`, `modules/secretmanager/variables.tf`
  - `modules/rds/main.tf`, `modules/rds/variables.tf`
- **How to use:**
  1. `cd 010-rds-awssm`
  2. Edit `main.tf` to set your desired username and password for the secret (or use variables).
  3. `terraform init`
  4. `terraform apply`
  5. After creation, connect to your RDS instance using the endpoint, username, and password stored in Secrets Manager.
  6. Example MySQL connection:
     ```sh
     mysql -h <rds-endpoint> -P 3306 -u <username> -p
     ```
     (You can find `<rds-endpoint>` in the AWS RDS console or Terraform outputs.)

- **Notes:**
  - Make sure your local MySQL client is compatible (MySQL 8.x recommended).
  - The RDS instance will use the credentials stored in AWS Secrets Manager, managed by the `secretmanager` module.
  - Security group and networking setup may be required to allow inbound connections from your IP.

---

### 011-rds-awssm-adv

- **Goal:** Provision an AWS RDS MySQL instance with credentials securely generated and stored in AWS Secrets Manager, and store all DB connection details (host, port, db name, username, password) in a separate secret for application use.
- **Files:** 
  - `main.tf`
  - `modules/secretmanager/main.tf`, `modules/secretmanager/variables.tf`
  - `modules/rds/main.tf`, `modules/rds/variables.tf`
- **How to use:**
  1. `cd 011-rds-awssm-adv`
  2. Edit `main.tf` to set your desired username for the secret (password will be randomly generated).
  3. `terraform init`
  4. `terraform apply`
  5. After creation, you will have:
     - A secret in AWS Secrets Manager with the DB credentials (username & random password).
     - A separate secret in AWS Secrets Manager containing all connection info (endpoint, port, db name, username, password).
     - An RDS instance using these credentials.
  6. Example MySQL connection:
     ```sh
     mysql -h <rds-endpoint> -P 3306 -u <username> -p
     ```
     (You can find `<rds-endpoint>`, username, and password in the connection info secret.)

- **Notes:**
  - The password is generated only once and remains stable unless you taint or change the random password resource.
  - Do **not** overwrite the credentials secret with connection info; always use a separate secret for connection details.
  - Security group and networking setup may be required to allow inbound connections from your IP.

---

### 012-import-example

- **Goal:** Import an existing AWS EC2 instance (created manually) into Terraform management.
- **Files:** 
  - `main.tf`
  - `imported-resources.tf` (generated during import, then merged into `main.tf`)
- **How to use:**
  1. **Create the EC2 instance manually** in the AWS Console.
  2. **Create a `main.tf`** with an import block:
     ```hcl
     import {
       id = "i-0e924e12540ecfa2f"
       to = aws_instance.imported_ec2_example
     }
     ```
  3. Initialize Terraform:
     ```sh
     terraform init
     ```
  4. Generate the resource configuration from the existing instance:
     ```sh
     terraform plan -generate-config-out=imported-resources.tf
     ```
  5. **Move the generated resource configuration** from `imported-resources.tf` into your `main.tf`.
  6. Import the resource into Terraform state:
     ```sh
     terraform import aws_instance.imported_ec2_example i-0e924e12540ecfa2f
     ```
  7. Now, your manually created EC2 instance is managed by Terraform!

- **Notes:**
  - After import, you can manage, update, or destroy the instance using Terraform as you would with any other resource.
  - Always review the generated configuration and adjust tags or settings as needed to match your infrastructure standards.

---

### 013-refresh-example

- **Goal:** Demonstrate how to use `terraform apply -refresh-only` to sync Terraform state with real infrastructure changes made outside of Terraform.
- **Files:** 
  - `main.tf`
- **How to use:**
  1. `cd 013-refresh-example`
  2. Deploy an EC2 instance using `terraform apply`.
  3. Make a manual change to the EC2 instance in the AWS Console (e.g., add or modify a tag).
  4. Run:
     ```sh
     terraform apply -refresh-only
     ```
     This updates the Terraform state file to reflect the real infrastructure.
  5. Run:
     ```sh
     terraform plan
     ```
     Terraform will show any differences between your configuration and the actual state (e.g., tags present in state but not in `main.tf`).
  6. To bring your configuration in sync, manually update your `main.tf` file as needed and run `terraform apply` again.

- **Notes:**
  - `terraform apply -refresh-only` only updates the state file; it does not change your infrastructure or configuration files.
  - Always review and manually update your configuration files to match desired state after using refresh-only.

---

### 014-eks-cluster

- **Goal:** Create a simple AWS EKS (Elastic Kubernetes Service) cluster and managed node group using Terraform modules.
- **Files:** 
  - `main.tf`
  - `provider.tf`
  - `modules/eks-cluster/main.tf`, `modules/eks-cluster/variables.tf`, `modules/eks-cluster/output.tf`
  - `modules/eks-nodes/main.tf`, `modules/eks-nodes/variables.tf`
- **How to use:**
  1. `cd 014-eks-cluster`
  2. Edit `main.tf` to set your desired cluster name, role names, and **replace the example subnet IDs with your actual subnet IDs**.
  3. `terraform init`
  4. `terraform apply`
  5. After creation, you will have:
     - An EKS control plane (cluster)
     - An EKS managed node group (worker nodes) attached to the cluster

- **Notes:**
  - Make sure your subnets are in the correct VPC and have the necessary networking for EKS.
  - You can retrieve the cluster name and subnet IDs via module outputs if needed for further configuration.
  - You may need to update your kubeconfig to connect to the new cluster:
    ```sh
    aws eks update-kubeconfig --region <region> --name <cluster_name>
    ```
  - Additional configuration (like security groups, IAM roles, and node group scaling) can be customized in the module variables.

---

### 015-eks-awsmodules

- **Goal:** Create an AWS EKS cluster and managed node groups using the official [terraform-aws-modules/eks/aws](https://github.com/terraform-aws-modules/terraform-aws-eks) module for production-ready, feature-rich EKS deployments.
- **Files:** 
  - `main.tf`
  - `variables.tf`
  - `terraform.tfvars`
- **How to use:**
  1. `cd 015-eks-awsmodules`
  2. Edit `terraform.tfvars` to set your cluster name, version, VPC ID, and subnet IDs.
  3. `terraform init`
  4. `terraform apply`
  5. After creation, you will have:
     - An EKS control plane (cluster) managed by the AWS EKS module
     - Multiple managed node groups (worker nodes) attached to the cluster
     - EKS add-ons like CoreDNS, kube-proxy, VPC CNI, and EKS Pod Identity Agent enabled by default

- **Notes:**
  - This example leverages the community-supported AWS EKS module for best practices and easier management.
  - You can customize node group settings, add-ons, and tags in `main.tf` and `terraform.tfvars`.
  - Make sure your subnets and VPC are properly configured for EKS.
  - Update your kubeconfig after creation:
    ```sh
    aws eks update-kubeconfig --region <region> --name <cluster_name>
    ```
  - For more advanced options, refer to the [module documentation](https://github.com/terraform-aws-modules/terraform-aws-eks)

---

### 016-functions

- **Goal:** Demonstrate the use of Terraform built-in functions for string manipulation and formatting.
- **Files:** 
  - `main.tf`
  - `variables.tf`
- **How to use:**
  1. `cd 016-functions`
  2. Review and edit `variables.tf` to set your desired prefix, suffix, and full name.
  3. `terraform init`
  4. `terraform apply`
  5. Observe the outputs, which show examples of:
     - String interpolation
     - `join`, `upper`, `lower`, `title`, `length`, `format`, and `replace` functions

- **Notes:**
  - This example is useful for learning how to manipulate and format strings in Terraform outputs and resource definitions.
  - You can extend this example to experiment with other Terraform functions as needed.

---

### 017-foreach

- **Goal:** Demonstrate the use of `for_each` in Terraform to dynamically create multiple resources based on a map variable.
- **Files:** 
  - `main.tf`
  - `variables.tf`
- **How to use:**
  1. `cd 017-foreach`
  2. Edit `variables.tf` to define your desired environments and their properties in the `environmentVariables` map.
  3. `terraform init`
  4. `terraform apply`
  5. Terraform will generate one `.env` file per environment, with content based on the map values.

- **Notes:**
  - This example uses the `local_file` resource to create environment-specific files, but the pattern can be used for any resource type.
  - You can expand the object in the map to include more fields as needed for your use case.

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
