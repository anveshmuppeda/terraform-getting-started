# 1. Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# 2. Random ID for unique naming
resource "random_id" "id" {
  byte_length = 8
}


# 4. VPC Endpoint for Secrets Manager
resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = var.rds_subnet_groups
  security_group_ids  = var.rds_security_group_ids
}

# 5. IAM Role for Lambda
resource "aws_iam_role" "rotation_lambda_role" {
  name = "SecretsManagerRotationRole-${random_id.id.hex}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# 6. IAM Policy for Lambda
resource "aws_iam_role_policy" "rotation_lambda_policy" {
  name = "SecretsManagerRotationPolicy-${random_id.id.hex}"
  role = aws_iam_role.rotation_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:PutSecretValue",
          "secretsmanager:UpdateSecretVersionStage"
        ]
        Resource = var.secretsmanager_arn
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetRandomPassword"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:AttachNetworkInterface",
          "ec2:DetachNetworkInterface"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "null_resource" "create_layer" {
  triggers = {
    requirements = filemd5("${path.module}/sourcecode/requirements.txt")
  }

  provisioner "local-exec" {
    command = <<-EOT
      cd ${path.module}
      rm -rf layer/python
      mkdir -p layer/python
      pip3 install -r sourcecode/requirements.txt -t layer/python/
      cd layer && zip -r ../pymysql_layer.zip . -x "*.pyc" "__pycache__/*"
    EOT

    environment = {
      PYTHONPATH = ""
    }
  }
}

resource "aws_lambda_layer_version" "pymysql_layer" {
  filename         = "${path.module}/pymysql_layer.zip"
  layer_name       = "pymysql-layer-${random_id.id.hex}"
  compatible_runtimes = ["python3.9"]
  
  depends_on = [null_resource.create_layer]
}


# 7. Create Lambda deployment package
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/sourcecode/"  # Directory with your Lambda code
  output_path = "${path.module}/rotation_lambda.zip"
}

# 8. Lambda Function
resource "aws_lambda_function" "rotation_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "SecretsManagerRotation-${random_id.id.hex}"
  role            = aws_iam_role.rotation_lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  layers = [aws_lambda_layer_version.pymysql_layer.arn]

  vpc_config {
    subnet_ids         = var.rds_subnet_groups
    security_group_ids = var.rds_security_group_ids
  }

  environment {
    variables = {
      SECRETS_MANAGER_ENDPOINT = "https://secretsmanager.${data.aws_region.current.name}.amazonaws.com"
    }
  }

  depends_on = [
    aws_iam_role_policy.rotation_lambda_policy,
    aws_vpc_endpoint.secretsmanager
  ]
}

# 9. Lambda permission for Secrets Manager
resource "aws_lambda_permission" "allow_secrets_manager" {
  statement_id  = "AllowExecutionFromSecretsManager"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rotation_lambda.function_name
  principal     = "secretsmanager.amazonaws.com"
}


# 11. Configure rotation
resource "aws_secretsmanager_secret_rotation" "rotation" {
  secret_id           = var.secretsmanager_id
  rotation_lambda_arn = aws_lambda_function.rotation_lambda.arn

  rotation_rules {
    automatically_after_days = 30
  }

  depends_on = [
    aws_lambda_permission.allow_secrets_manager,
    aws_vpc_endpoint.secretsmanager
  ]
}

# 12. Outputs
output "rotation_lambda_arn" {
  description = "ARN of the rotation Lambda function"
  value       = aws_lambda_function.rotation_lambda.arn
}
