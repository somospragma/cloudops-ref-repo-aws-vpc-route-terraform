# Recursos principales del módulo (PC-IAC-010, PC-IAC-023)

############################################################################
# AWS VPC Routes
#
# Crea una ruta por cada entrada en var.route_config usando for_each
# para garantizar la estabilidad del estado de Terraform (PC-IAC-010).
#
# NOTA IMPORTANTE: El recurso aws_route en AWS NO soporta el atributo `tags`.
# Por este motivo, no se aplica el bloque tags en este recurso.
# Para identificar las rutas, use el identificador lógico (clave del mapa)
# que se refleja en el estado de Terraform como:
# aws_route.this["<clave>"]
############################################################################

resource "aws_route" "this" {
  provider = aws.project # Referencia explícita al alias (PC-IAC-005)

  for_each = local.route_config_normalized # Uso de for_each para estabilidad (PC-IAC-010)

  # Destino de la ruta (obligatorio)
  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.destination_cidr_block

  # Targets de la ruta - solo se aplica el que está configurado (no nulo)
  transit_gateway_id        = each.value.transit_gateway_id
  nat_gateway_id            = each.value.nat_gateway_id
  gateway_id                = each.value.gateway_id
  vpc_endpoint_id           = each.value.vpc_endpoint_id
  network_interface_id      = each.value.network_interface_id
  vpc_peering_connection_id = each.value.vpc_peering_connection_id
  core_network_arn          = each.value.core_network_arn

  # Timeout extendido para TGW attachments que pueden tardar en propagarse
  timeouts {
    create = "5m"
  }
}
