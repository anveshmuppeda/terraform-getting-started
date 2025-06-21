# import {
#   id = "i-0e924e12540ecfa2f"
#   to = aws_instance.imported_ec2_example
# }


resource "aws_instance" "imported_ec2_example" {
  ami                                  = "ami-09e6f87a47903347c"
  instance_type                        = "t2.micro"
  tags = {
    Name = "ManualServerImportedtoTerraform"
  }
  tags_all = {
    Name = "ManualServer"
  }
}
