# Outputs del ejemplo (PC-IAC-007)
# Expone los outputs del módulo para validar la infraestructura del ejemplo

output "route_ids" {
  description = "Mapa de IDs de las rutas VPC creadas por el módulo."
  value       = module.vpc_routes.route_ids
}

output "route_states" {
  description = "Mapa de estados de las rutas VPC creadas por el módulo."
  value       = module.vpc_routes.route_states
}

output "route_table_ids" {
  description = "Mapa de IDs de route tables utilizadas."
  value       = module.vpc_routes.route_table_ids
}

output "destination_cidr_blocks" {
  description = "Mapa de CIDRs de destino de las rutas creadas."
  value       = module.vpc_routes.destination_cidr_blocks
}
