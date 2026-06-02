# Configuración de providers para el ejemplo (PC-IAC-005, PC-IAC-026)
# En el ejemplo (sample/), el provider se configura directamente con alias "principal"
# que luego se mapea a aws.project al invocar el módulo padre.

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.31.0"
    }
  }
  # Sin backend configurado: el estado del ejemplo es local (PC-IAC-026)
}

provider "aws" {
  alias  = "principal"
  region = var.region

  # En pipelines: configurar assume_role con var.deploy_role_arn (PC-IAC-005)
  # assume_role {
  #   role_arn = var.deploy_role_arn
  # }

  default_tags {
    tags = {
      Client      = var.client
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}
