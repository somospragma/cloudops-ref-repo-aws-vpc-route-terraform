# Variables del ejemplo (PC-IAC-026)

############################################################################
# Variables de Gobernanza
############################################################################

variable "client" {
  description = "Nombre del cliente para nomenclatura y tagging."
  type        = string
}

variable "project" {
  description = "Nombre del proyecto."
  type        = string
}

variable "environment" {
  description = "Entorno de despliegue (dev, qa, pdn)."
  type        = string
}

variable "region" {
  description = "Región de AWS para el despliegue."
  type        = string
  default     = "us-east-1"
}

############################################################################
# Variable de Configuración de Rutas
# Los campos de IDs se dejan vacíos aquí para que sean llenados
# automáticamente desde data sources en locals.tf (PC-IAC-026)
############################################################################

variable "route_config" {
  description = <<-EOT
    Mapa de configuración de rutas VPC para el ejemplo.
    Los campos de IDs (route_table_id, transit_gateway_id, nat_gateway_id)
    pueden dejarse vacíos para que sean llenados automáticamente desde
    data sources en locals.tf, o pueden especificarse directamente.
  EOT
  type = map(object({
    destination_cidr_block    = string
    route_table_id            = optional(string, "")
    transit_gateway_id        = optional(string, "")
    nat_gateway_id            = optional(string, "")
    gateway_id                = optional(string, "")
    vpc_endpoint_id           = optional(string, "")
    network_interface_id      = optional(string, "")
    vpc_peering_connection_id = optional(string, "")
    core_network_arn          = optional(string, "")
    # Indicadores para selección automática del target desde data sources
    use_tgw_from_data  = optional(bool, false)
    use_nat_from_data  = optional(bool, false)
    use_rt_from_data   = optional(string, "") # Clave para seleccionar RT desde data
  }))
  default = {}
}
