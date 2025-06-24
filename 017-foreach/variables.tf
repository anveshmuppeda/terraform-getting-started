variable "environmentVariables" {
  description = "A map of environment variables to be used in the container"
  type        = map(object({
    Application  = string
    Environment  = string
    Version      = string
    Description  = string
    Owner        = string
  }))
  default = {
    "development" = {
      Application = "MyApp"
      Environment = "Development"
      Version     = "1.0.0"
      Description = "Development environment for MyApp"
      Owner       = "DevTeam"
    }
    "staging" = {
      Application = "MyApp"
      Environment = "Staging"
      Version     = "1.0.0"
      Description = "Staging environment for MyApp"
      Owner       = "QA Team"
    }
    "production" = {
      Application = "MyApp"
      Environment = "Production"
      Version     = "1.0.0"
      Description = "Production environment for MyApp"
      Owner       = "Ops Team" 
    }
  }
}