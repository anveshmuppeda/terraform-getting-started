# IAM Role for EC2 instance
resource "aws_iam_role" "ec2_cloudwatch_role" {
  name = var.win_iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "ssm.amazonaws.com",
            "ec2.amazonaws.com"
          ]
        }
      }
    ]
  })

  tags = {
    Name = "Windows EC2 CloudWatch Role"
  }
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
    role = aws_iam_role.ec2_cloudwatch_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMMaintenanceWindowRole"
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_policy" {
  role = aws_iam_role.ec2_cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "windows_ssm_cloudwatch_instance_profile" {
  name = "WindowsSSMCloudWatchInstanceProfile"
  role = aws_iam_role.ec2_cloudwatch_role.name
}

resource "aws_security_group" "windows_sg" {
  name_prefix = "windows-sg-"
  description = "Security group for MySQL server"

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this to your IP for security
  }

  # RDP access
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this to your IP for security
  }

  # HTTP (optional, for web applications)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS (optional, for web applications)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "windows-security-group"
  }
}

# User data script to configure CloudWatch
locals {
  cloudwatch_config = file("${path.module}/AWS.EC2.Windows.CloudWatch.json")

  user_data = base64encode(templatefile("${path.module}/user_data.ps1", {
    cloudwatch_config = local.cloudwatch_config
  }))
}

resource "aws_instance" "windows_server" {
  ami = var.windows_amiid
  instance_type = "t3.medium"
  key_name = var.key_name
  vpc_security_group_ids = [ aws_security_group.windows_sg.id ]
  iam_instance_profile = aws_iam_instance_profile.windows_ssm_cloudwatch_instance_profile.name

  user_data = local.user_data

  tags = {
    Name            = var.server_name
    Application     = "Windows CloudWatch Integration"
    Type            = "Windows"
  }
}