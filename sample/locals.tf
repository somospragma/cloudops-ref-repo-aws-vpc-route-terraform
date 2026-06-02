# Transformaciones del ejemplo (PC-IAC-026)
# Inyección de IDs dinámicos desde data sources y construcción del payload final

locals {
  # Prefijo de gobernanza (PC-IAC-025)
  governance_prefix = "${var.client}-${var.project}-${var.environment}"

  # IDs dinámicos obtenidos desde data sources
  tgw_id            = data.aws_ec2_transit_gateway.hub.id
  nat_az1_id        = data.aws_nat_gateway.hub_az1.id
  rt_hub_nat_az1_id = data.aws_route_table.hub_nat_az1.id
  rt_spoke_priv_id  = data.aws_route_table.spoke_private.id

  # Transformar configuración inyectando IDs dinámicos (PC-IAC-009, PC-IAC-026)
  # Para cada ruta en var.route_config, resolver los IDs vacíos usando data sources
  route_config_transformed = {
    for key, config in var.route_config : key => {
      destination_cidr_block = config.destination_cidr_block

      # Resolver route_table_id: usar el valor del tfvars si está definido,
      # de lo contrario usar la data source indicada por use_rt_from_data
      route_table_id = length(config.route_table_id) > 0 ? config.route_table_id : (
        config.use_rt_from_data == "hub_nat_az1" ? local.rt_hub_nat_az1_id : (
          config.use_rt_from_data == "spoke_private" ? local.rt_spoke_priv_id : ""
        )
      )

      # Resolver transit_gateway_id
      transit_gateway_id = (
        length(config.transit_gateway_id) > 0 ? config.transit_gateway_id : (
          config.use_tgw_from_data ? local.tgw_id : ""
        )
      )

      # Resolver nat_gateway_id
      nat_gateway_id = (
        length(config.nat_gateway_id) > 0 ? config.nat_gateway_id : (
          config.use_nat_from_data ? local.nat_az1_id : ""
        )
      )

      # Otros targets se pasan directamente sin transformación
      gateway_id                = config.gateway_id
      vpc_endpoint_id           = config.vpc_endpoint_id
      network_interface_id      = config.network_interface_id
      vpc_peering_connection_id = config.vpc_peering_connection_id
      core_network_arn          = config.core_network_arn
    }
  }
}
