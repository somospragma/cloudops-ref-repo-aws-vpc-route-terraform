# Requisitos de versión de Terraform y providers (PC-IAC-006)
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.31.0"
      configuration_aliases = [aws.project] # Alias Consumidor Obligatorio (PC-IAC-005)
    }
  }
}
