resource "aws_instance" "my_first_instance" {
  ami           = "ami-09e6f87a47903347c" # Example AMI ID, replace with a valid one for your region
  instance_type = "t2.micro"
  tags = {
    Name = "MyFirstInstance"
  }
}