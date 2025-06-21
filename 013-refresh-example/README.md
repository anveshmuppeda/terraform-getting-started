Simulating terraform refresh with a simple example.
Created a ec2 server using the terraform script in the `main.tf` file.
then added new tag to the ec2 server using the AWS console.
Then ran `terraform apply -refresh-only` to update the state file with the new tag.
once the state file is updated, we can see the new tag in the state file.
then when I ran the terraform plan, it shows changes to be applied, which is the new tag that was added to the ec2 server and state file. But not added on the main.tf file.
This is because the `terraform apply -refresh-only` command only updates the state file with the current state of the infrastructure, it does not modify the configuration files.

So if we need these changes to be reflected in the configuration files, we need to manually add them to the `main.tf` file.

So, in my case I added the new tag to the `main.tf` file and then ran `terraform apply` to apply the changes but it did not apply any changes as the state file and the configuration files are now in sync.

> terraform apply -refresh-only
module.MyFirstModuleApp.aws_security_group.main: Refreshing state... [id=sg-0ca63bb8a89fca805]
module.MyFirstModuleApp.aws_instance.ec2_example: Refreshing state... [id=i-04bb7b498483f5b2f]

Note: Objects have changed outside of Terraform

Terraform detected the following changes made outside of Terraform since the last "terraform apply" which may have affected this plan:

  # module.MyFirstModuleApp.aws_instance.ec2_example has changed
  ~ resource "aws_instance" "ec2_example" {
        id                                   = "i-04bb7b498483f5b2f"
      ~ tags                                 = {
          + "Env"  = "Dev"
            "Name" = "MyFirstInstanceFromModule"
        }
      ~ tags_all                             = {
          + "Env"  = "Dev"
            # (1 unchanged element hidden)
        }
        # (38 unchanged attributes hidden)

        # (8 unchanged blocks hidden)
    }

  # module.MyFirstModuleApp.aws_security_group.main has changed
  ~ resource "aws_security_group" "main" {
        id                     = "sg-0ca63bb8a89fca805"
        name                   = "terraform-example-sg"
      + tags                   = {}
        # (10 unchanged attributes hidden)
    }


This is a refresh-only plan, so Terraform will not take any actions to undo these. If you were expecting these changes then you can apply this
plan to record the updated values in the Terraform state without changing any remote objects.

Would you like to update the Terraform state to reflect these detected changes?
  Terraform will write these changes to the state without modifying any real infrastructure.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes


Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
> terraform plan
module.MyFirstModuleApp.aws_security_group.main: Refreshing state... [id=sg-0ca63bb8a89fca805]
module.MyFirstModuleApp.aws_instance.ec2_example: Refreshing state... [id=i-04bb7b498483f5b2f]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # module.MyFirstModuleApp.aws_instance.ec2_example will be updated in-place
  ~ resource "aws_instance" "ec2_example" {
        id                                   = "i-04bb7b498483f5b2f"
      ~ tags                                 = {
          - "Env"  = "Dev" -> null
            "Name" = "MyFirstInstanceFromModule"
        }
      ~ tags_all                             = {
          - "Env"  = "Dev" -> null
            # (1 unchanged element hidden)
        }
        # (38 unchanged attributes hidden)

        # (8 unchanged blocks hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform
apply" now.
> terraform plan
module.MyFirstModuleApp.aws_security_group.main: Refreshing state... [id=sg-0ca63bb8a89fca805]
module.MyFirstModuleApp.aws_instance.ec2_example: Refreshing state... [id=i-04bb7b498483f5b2f]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

