## 012-import-example

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