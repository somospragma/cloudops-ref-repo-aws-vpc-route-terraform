# Valores locales y transformaciones (PC-IAC-012)

locals {
  # Prefijo de gobernanza para nomenclatura (PC-IAC-003)
  governance_prefix = "${var.client}-${var.project}-${var.environment}"

  # Tags base del módulo (PC-IAC-004)
  # Nota: aws_route NO soporta el atributo tags en AWS.
  # Estos tags base se usan únicamente como referencia interna y documentación.
  base_module_tags = {
    "managed-by" = "terraform"
    "module"     = "vpc-route"
  }

  # Mapa normalizado de la configuración de rutas con valores nulos explícitos
  # para targets no especificados. Esto permite referenciarlos de forma segura
  # en main.tf usando el operador ternario. (PC-IAC-009)
  route_config_normalized = {
    for key, config in var.route_config : key => {
      route_table_id         = config.route_table_id
      destination_cidr_block = config.destination_cidr_block

      # Convertir strings vacíos a null para que Terraform no los envíe a la API
      transit_gateway_id        = length(config.transit_gateway_id) > 0 ? config.transit_gateway_id : null
      nat_gateway_id            = length(config.nat_gateway_id) > 0 ? config.nat_gateway_id : null
      gateway_id                = length(config.gateway_id) > 0 ? config.gateway_id : null
      vpc_endpoint_id           = length(config.vpc_endpoint_id) > 0 ? config.vpc_endpoint_id : null
      network_interface_id      = length(config.network_interface_id) > 0 ? config.network_interface_id : null
      vpc_peering_connection_id = length(config.vpc_peering_connection_id) > 0 ? config.vpc_peering_connection_id : null
      core_network_arn          = length(config.core_network_arn) > 0 ? config.core_network_arn : null
    }
  }
}
