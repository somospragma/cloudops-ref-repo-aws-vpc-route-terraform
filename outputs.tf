# Outputs del módulo (PC-IAC-007, PC-IAC-014)

output "route_ids" {
  description = "Mapa de IDs de las rutas creadas, indexado por la clave lógica de configuración. El ID de una ruta en AWS es la combinación de route_table_id y destination_cidr_block."
  value       = { for k, v in aws_route.this : k => v.id }
}

output "route_states" {
  description = "Mapa de estados de las rutas creadas (active, blackhole, etc.), indexado por la clave lógica de configuración."
  value       = { for k, v in aws_route.this : k => v.state }
}

output "route_table_ids" {
  description = "Mapa de IDs de las route tables utilizadas, indexado por la clave lógica de configuración."
  value       = { for k, v in aws_route.this : k => v.route_table_id }
}

output "destination_cidr_blocks" {
  description = "Mapa de CIDRs de destino de las rutas creadas, indexado por la clave lógica de configuración."
  value       = { for k, v in aws_route.this : k => v.destination_cidr_block }
}
