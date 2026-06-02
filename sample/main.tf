# Invocación del módulo padre (PC-IAC-026)
# Solo contiene el bloque module - sin bloques locals

############################################################################
# Invocación del Módulo VPC Route
############################################################################

module "vpc_routes" {
  source = "../" # Apunta al módulo padre (PC-IAC-026)

  # B. Providers (PC-IAC-005, PC-IAC-013)
  providers = {
    aws.project = aws.principal
  }

  # C. Variables de Gobernanza (PC-IAC-003, PC-IAC-013)
  client      = var.client
  project     = var.project
  environment = var.environment

  # E. Variables de Configuración - configuración transformada desde locals (PC-IAC-026)
  route_config = local.route_config_transformed
}
