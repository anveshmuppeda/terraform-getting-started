resource "aws_instance" "my_first_instance" {
  ami           = var.amiid # Example AMI ID, replace with a valid one for your region
  instance_type = var.instance_type
  tags = {
    Name = var.instance_name
  }
}