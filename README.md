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
├── 017-foreach
├── 018-conditional-logic
├── 019-conditional-logic-2
├── 020-conditional-logic-3
├── 021-kind-cluster
├── 022-deploy-pod-on-kind
├── 023-deploy-helm-on-kind
├── 024-rds-secret-rotation
├── 025-ec2-with-mysql-restapi
├── 026-wind-logs-cloudwatch
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

### 018-conditional-logic

- **Goal:** Demonstrate the use of conditional expressions in Terraform to dynamically set values based on input variables.
- **Files:** 
  - `main.tf`
  - `variables.tf`
- **How to use:**
  1. `cd 018-conditional-logic`
  2. Edit `variables.tf` to set the `age` variable as desired.
  3. `terraform init`
  4. `terraform apply`
  5. Terraform will generate a `vote_eligibility.txt` file indicating whether the user is eligible to vote based on the provided age.

- **Notes:**
  - This example uses a local value with a conditional expression (`var.age >= 18 ? "Eligible to Vote" : "Not Eligible to Vote"`).
  - You can use similar logic for any dynamic decision-making in your Terraform configurations.

---

### 019-conditional-logic-2

- **Goal:** Demonstrate conditional resource creation in Terraform using the `count` meta-argument and boolean variables.
- **Files:** 
  - `main.tf`
  - `variables.tf`
  - `terraform.tfvars`
- **How to use:**
  1. `cd 019-conditional-logic-2`
  2. Edit `terraform.tfvars` or `variables.tf` to set `is_development` or `is_production` to `true` as needed.
  3. `terraform init`
  4. `terraform apply`
  5. Terraform will create either a `dev_file.txt`, a `prod_file.txt`, or both, depending on which variables are set to `true`.

- **Notes:**
  - This example uses the `count` argument with a conditional expression to control whether each resource is created.
  - You can use this pattern to conditionally manage any resource in Terraform based on environment or other criteria.

---

### 020-conditional-logic-3

- **Goal:** Demonstrate advanced conditional logic and filtering in Terraform using `for_each` with dynamic maps and conditions.
- **Files:** 
  - `main.tf`
- **How to use:**
  1. `cd 020-conditional-logic-3`
  2. Review or edit the `file_names` map and the filtering logic in `main.tf`.
  3. `terraform init`
  4. `terraform apply`
  5. Terraform will create files for each environment (dev, prod, stage), but will **not** create files that are filtered out (e.g., `do_not_create_file.txt`).

- **Notes:**
  - This example uses a `for_each` with a filtered map to control which resources are created.
  - You can easily adjust the filtering condition to include or exclude files/resources as needed for your use case.
  - This pattern is useful for managing resources dynamically based on environment or other criteria.

---

### 021-kind-cluster

- **Goal:** Create a local Kubernetes cluster using [Kind](https://kind.sigs.k8s.io/) (Kubernetes IN Docker) with Terraform.
- **Files:** 
  - `main.tf`
  - `provider.tf`
  - `variable.tf`
- **How to use:**
  1. `cd 021-kind-cluster`
  2. Edit `variable.tf` to set your desired cluster name and kubeconfig path if needed.
  3. `terraform init`
  4. `terraform apply`
  5. After creation, a Kind cluster will be running locally and the kubeconfig will be written to the specified path (default: `~/.kube/config`).

- **Notes:**
  - Requires Docker to be running on your machine.
  - The `kind` Terraform provider is used to manage the lifecycle of the Kind cluster.
  - You can use the generated kubeconfig with `kubectl` or other Kubernetes tools to interact with your local cluster.
  - This is useful for local development, testing, and CI/CD

---

### 022-deploy-pod-on-kind

- **Goal:** Deploy an Nginx pod and service on a local Kind (Kubernetes IN Docker) cluster using Terraform.
- **Files:** 
  - `main.tf`
  - `provider.tf`
  - `variables.tf`
- **How to use:**
  1. `cd 022-deploy-pod-on-kind`
  2. Edit `variables.tf` to set your desired Kind cluster name, kubeconfig path, deployment name, and namespace if needed.
  3. `terraform init`
  4. `terraform apply`
  5. Terraform will:
     - Create a Kind cluster (if not already present)
     - Deploy an Nginx deployment with 2 replicas
     - Expose it via a ClusterIP service

- **Notes:**
  - Requires Docker to be running on your machine.
  - The `kind` provider manages the Kind cluster, and the `kubernetes` provider deploys resources using the generated kubeconfig.
  - After apply, use the output command to port-forward and access Nginx locally:
    ```sh
    kubectl port-forward service/nginx-service 8080:80 -n default
    ```
  - You can customize the deployment and service by editing the variables or resource definitions.

---

### 023-deploy-helm-on-kind

- **Goal:** Deploy a Helm chart (e.g., Nginx) onto a local Kind (Kubernetes IN Docker) cluster using Terraform.
- **Files:** 
  - `main.tf`
  - `provider.tf`
  - `variables.tf`
  - `nginx-chart/` (your local Helm chart directory)
- **How to use:**
  1. `cd 023-deploy-helm-on-kind`
  2. Edit `variables.tf` to set your Kind cluster name, kubeconfig path, deployment name, and namespace as needed.
  3. `terraform init`
  4. `terraform apply`
  5. Terraform will:
     - Create a Kind cluster (if not already present)
     - Deploy your Helm chart (e.g., Nginx) to the cluster using the Helm provider

- **Notes:**
  - Requires Docker to be running on your machine.
  - The `kind` provider manages the Kind cluster, the `kubernetes` provider interacts with the cluster, and the `helm` provider deploys Helm charts.
  - You can customize the Helm release by editing the `set` block in `main.tf` or by modifying your Helm chart.
  - After apply, you can use `kubectl` with the generated kubeconfig to inspect resources:
    ```sh
    kubectl get all -n <namespace>
    ```
  - This pattern is useful for local development, CI/CD pipelines, and testing Helm charts

---

### 024-rds-secret-rotation

- **Goal:** Provision an AWS RDS MySQL instance with credentials stored in AWS Secrets Manager and enable automatic password rotation using a Lambda function.
- **Files:** 
  - `main.tf`
  - `providers.tf`
  - `variables.tf`
  - `modules/db_network/main.tf`, `modules/db_network/variables.tf`
  - `modules/rds/main.tf`, `modules/rds/variables.tf`
  - `modules/lambda_rotation/main.tf`, `modules/lambda_rotation/variables.tf`
- **How to use:**
  1. `cd 024-rds-secret-rotation`
  2. Edit `variables.tf` or `terraform.tfvars` to set your RDS instance and secret names if needed.
  3. `terraform init`
  4. `terraform apply`
  5. Terraform will:
     - Create a VPC, subnets, and security group for RDS.
     - Deploy an RDS MySQL instance.
     - Store the RDS credentials (username, password, host, port, dbname) in AWS Secrets Manager.
     - Deploy a Lambda function (with PyMySQL layer) for secret rotation.
     - Set up a VPC endpoint for Secrets Manager and all required IAM roles/policies.
     - Enable automatic rotation of the RDS secret every 30 days.

- **Notes:**
  - The Lambda function and its layer are built automatically from the `sourcecode` and `requirements.txt` in the `lambda_rotation` module.
  - The RDS secret in Secrets Manager will always have the latest connection info and credentials.
  - You can customize subnet count, VPC CIDR, and security group rules in the `db_network` module.
  - This setup is suitable for production-grade RDS deployments requiring secure, automated credential rotation.

---  

### 025-ec2-with-mysql-restapi

- **Goal:** Provision an EC2 instance running MySQL and a Flask REST API, with all setup automated via Terraform and a user data script.
- **Files:** 
  - `main.tf`
  - `providers.tf`
  - `terraform.tfvars`
  - `install_mysql_flask.sh` (user data script)
- **How to use:**
  1. `cd 025-ec2-with-mysql-restapi`
  2. Edit `terraform.tfvars` to set your key pair name, MySQL root password, app DB password, and instance type.
  3. Make sure you have an Ubuntu AMI ID set in your variables (e.g., via `variables.tf` or as a variable override).
  4. `terraform init`
  5. `terraform apply`
  6. After creation, you will have:
     - An EC2 instance with MySQL installed and secured.
     - A Flask REST API running as a systemd service, connected to the MySQL database.
     - Security group rules for SSH, MySQL (internal), Flask (port 5000), HTTP, and HTTPS.
     - Output values for public/private IP, API endpoints, and SSH connection command.

- **Notes:**
  - The Flask app provides `/health`, `/entries` (GET/POST) endpoints for a simple guestbook.
  - All setup is handled by the `install_mysql_flask.sh` script via EC2 user data.
  - Use the output `flask_app_url` and `health_check_url` to test the API.
  - The `check_services.sh` script on the instance helps verify MySQL and Flask status.
  - Make sure your key pair exists in AWS and you have the corresponding `.pem` file for SSH.

---

### 026-wind-logs-cloudwatch

- **Goal:** Launch a Windows EC2 instance with CloudWatch integration for logs and metrics, using Terraform and PowerShell user data.
- **Files:** 
  - `main.tf`
  - `variables.tf`
  - `AWS.EC2.Windows.CloudWatch.json` (CloudWatch agent config)
  - `user_data.ps1` (PowerShell script for setup)
- **How to use:**
  1. `cd 026-wind-logs-cloudwatch`
  2. Edit `variables.tf` to set your Windows AMI ID, key pair, server name, and IAM role name as needed.
  3. `terraform init`
  4. `terraform apply`
  5. Terraform will:
     - Create an IAM role and instance profile for SSM and CloudWatch.
     - Create a security group for RDP, SSH, HTTP, and HTTPS access.
     - Launch a Windows EC2 instance with the IAM role and security group.
     - Use a PowerShell user data script to:
       - Configure the CloudWatch agent with the provided JSON config.
       - Enable IIS and logging.
       - Enable and audit Windows Event Logs.
       - Create a sample log entry and custom logs directory.
       - Restart the SSM agent to pick up the new config.

- **Notes:**
  - The instance will send Windows Event Logs, IIS logs, and custom logs to CloudWatch Logs.
  - You can customize which logs and metrics are collected by editing `AWS.EC2.Windows.CloudWatch.json`.
  - The PowerShell script (`user_data.ps1`) is base64-encoded and passed as user data to the instance.
  - Make sure your key pair exists in AWS and you have the corresponding `.pem` file for RDP/SSH.
  - After launch, check the CloudWatch Log Groups in the AWS Console for logs from your

---



## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- AWS account and credentials configured (`aws configure` or environment variables)
- An existing AWS key pair for EC2 instances

---

## License

See [LICENSE](LICENSE) for details.

---

## References  
1. [Manage Kubernetes resources via Terraform](https://developer.hashicorp.com/terraform/tutorials/kubernetes). 
2. [Kind Provider](https://registry.terraform.io/providers/tehcyx/kind/latest/docs). 
3. [Helm Provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs). 
4. [Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#credentials-config). 
5. [aws-secrets-manager-rotation-lambdas](https://github.com/aws-samples/aws-secrets-manager-rotation-lambdas/blob/master/SecretsManagerRDSMySQLRotationSingleUser/lambda_function.py)


**Happy Terraforming!**
