# Variables de entrada del módulo (PC-IAC-002)

############################################################################
# Variables de Gobernanza (Obligatorias - PC-IAC-002)
############################################################################

variable "client" {
  description = "Nombre del cliente o unidad de negocio para nomenclatura y tagging."
  type        = string

  validation {
    condition     = length(var.client) > 0 && length(var.client) <= 10
    error_message = "El cliente debe tener entre 1 y 10 caracteres."
  }
}

variable "project" {
  description = "Nombre del proyecto para nomenclatura y tagging."
  type        = string

  validation {
    condition     = length(var.project) > 0 && length(var.project) <= 15
    error_message = "El proyecto debe tener entre 1 y 15 caracteres."
  }
}

variable "environment" {
  description = "Entorno de despliegue. Valores permitidos: dev, qa, pdn, stg, uat."
  type        = string

  validation {
    condition     = contains(["dev", "qa", "pdn", "stg", "uat"], var.environment)
    error_message = "El entorno debe ser uno de: dev, qa, pdn, stg, uat."
  }
}

############################################################################
# Variable de Configuración Principal (PC-IAC-002, PC-IAC-009, PC-IAC-010)
############################################################################

variable "route_config" {
  description = <<-EOT
    Mapa de configuración de rutas VPC. Cada clave es un identificador lógico
    único de la ruta (usado como referencia en el estado de Terraform).
    
    Campos obligatorios:
    - route_table_id: ID de la route table donde se creará la ruta.
    - destination_cidr_block: CIDR de destino de la ruta (IPv4).
    
    Campos opcionales (al menos uno de los targets debe especificarse):
    - transit_gateway_id: ID del Transit Gateway de destino.
    - nat_gateway_id: ID del NAT Gateway de destino.
    - gateway_id: ID del Internet Gateway o Virtual Private Gateway de destino.
    - vpc_endpoint_id: ID del VPC Endpoint de destino.
    - network_interface_id: ID de la interfaz de red de destino.
    - vpc_peering_connection_id: ID de la conexión de VPC Peering de destino.
    - core_network_arn: ARN del Core Network (AWS Cloud WAN) de destino.
    
    Nota: aws_route NO soporta el atributo tags en AWS. La etiqueta Name
    y additional_tags se usan solo para identificación lógica interna.
    Ver README para más información.
    
    Ejemplo (Hub-Spoke):
    route_config = {
      "retorno-spoke-a" = {
        route_table_id         = "rtb-xxxxxxxx"
        destination_cidr_block = "10.34.0.0/16"
        transit_gateway_id     = "tgw-xxxxxxxx"
      }
    }
  EOT
  type = map(object({
    # Campos obligatorios
    route_table_id         = string
    destination_cidr_block = string

    # Targets opcionales - al menos uno debe especificarse
    transit_gateway_id        = optional(string, "")
    nat_gateway_id            = optional(string, "")
    gateway_id                = optional(string, "")
    vpc_endpoint_id           = optional(string, "")
    network_interface_id      = optional(string, "")
    vpc_peering_connection_id = optional(string, "")
    core_network_arn          = optional(string, "")
  }))
  default = {}

  validation {
    condition     = alltrue([for k, v in var.route_config : length(v.route_table_id) > 0])
    error_message = "Cada ruta debe tener un route_table_id definido y no vacío."
  }

  validation {
    condition     = alltrue([for k, v in var.route_config : can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", v.destination_cidr_block))])
    error_message = "destination_cidr_block debe ser un CIDR IPv4 válido (ej. 10.0.0.0/8)."
  }

  validation {
    condition = alltrue([
      for k, v in var.route_config : (
        length(v.transit_gateway_id) > 0 ||
        length(v.nat_gateway_id) > 0 ||
        length(v.gateway_id) > 0 ||
        length(v.vpc_endpoint_id) > 0 ||
        length(v.network_interface_id) > 0 ||
        length(v.vpc_peering_connection_id) > 0 ||
        length(v.core_network_arn) > 0
      )
    ])
    error_message = "Cada ruta debe especificar al menos un target (transit_gateway_id, nat_gateway_id, gateway_id, vpc_endpoint_id, network_interface_id, vpc_peering_connection_id o core_network_arn)."
  }
}
