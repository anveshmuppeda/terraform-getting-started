1. `terraform init`
2. `terraform plan -generate-config-out=imported-resources.tf`
3. `terraform import aws_instance.imported_ec2_example i-0e924e12540ecfa2f`