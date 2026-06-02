# cloudops-ref-repo-aws-vpc-route-terraform

Módulo de referencia Terraform para gestionar rutas AWS VPC (`aws_route`). Permite crear y gestionar rutas en cualquier tipo de route table (subnets, NAT Gateway edge association, TGW route tables), soportando múltiples tipos de destino.

---

## ⚠️ Nota Importante: Tags en aws_route

El recurso `aws_route` de AWS **no soporta el atributo `tags`**. Esta es una limitación del servicio, no del módulo. Las rutas se identifican por la combinación de `route_table_id` + `destination_cidr_block`.

Para identificar las rutas en el estado de Terraform, use la clave del mapa `route_config`, que se refleja como `aws_route.this["<clave>"]`.

---

## Casos de Uso

### Hub-Spoke con Transit Gateway

**Rutas de retorno en route table del NAT Gateway regional:**
```hcl
route_config = {
  "retorno-spoke-a" = {
    route_table_id         = "rtb-xxxxxxxx"   # Route table del NAT GW
    destination_cidr_block = "10.34.0.0/16"   # CIDR del spoke A
    transit_gateway_id     = "tgw-xxxxxxxx"
  },
  "retorno-spoke-b" = {
    route_table_id         = "rtb-xxxxxxxx"
    destination_cidr_block = "10.35.0.0/16"   # CIDR del spoke B
    transit_gateway_id     = "tgw-xxxxxxxx"
  }
}
```

**Rutas en subnets de VPC spoke:**
```hcl
route_config = {
  "default-via-nat" = {
    route_table_id         = "rtb-yyyyyyyy"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = "nat-xxxxxxxx"
  },
  "privado-via-tgw" = {
    route_table_id         = "rtb-yyyyyyyy"
    destination_cidr_block = "10.0.0.0/8"
    transit_gateway_id     = "tgw-xxxxxxxx"
  }
}
```

---

## Uso del Módulo

```hcl
module "vpc_routes" {
  source = "git::https://github.com/somospragma/cloudops-ref-repo-aws-vpc-route-terraform.git?ref=v1.0.0"

  providers = {
    aws.project = aws.principal
  }

  # Variables de gobernanza
  client      = var.client
  project     = var.project
  environment = var.environment

  # Configuración de rutas (construida en locals.tf del Root - PC-IAC-025)
  route_config = local.route_config_final
}
```

---

## Requirements

| Nombre | Versión |
|--------|---------|
| terraform | >= 1.0.0 |
| aws | >= 4.31.0 |

## Providers

| Nombre | Versión |
|--------|---------|
| aws.project | >= 4.31.0 |

---

## Variables

| Nombre | Descripción | Tipo | Requerido |
|--------|-------------|------|-----------|
| `client` | Nombre del cliente o unidad de negocio | `string` | Sí |
| `project` | Nombre del proyecto | `string` | Sí |
| `environment` | Entorno de despliegue (dev, qa, pdn, stg, uat) | `string` | Sí |
| `route_config` | Mapa de configuración de rutas VPC | `map(object)` | No (default `{}`) |

### Estructura de `route_config`

```hcl
map(object({
  route_table_id            = string           # Obligatorio
  destination_cidr_block    = string           # Obligatorio (CIDR IPv4)
  transit_gateway_id        = optional(string) # Target: TGW
  nat_gateway_id            = optional(string) # Target: NAT GW
  gateway_id                = optional(string) # Target: IGW o VGW
  vpc_endpoint_id           = optional(string) # Target: VPC Endpoint
  network_interface_id      = optional(string) # Target: ENI
  vpc_peering_connection_id = optional(string) # Target: VPC Peering
  core_network_arn          = optional(string) # Target: AWS Cloud WAN
}))
```

---

## Outputs

| Nombre | Descripción |
|--------|-------------|
| `route_ids` | Mapa de IDs de rutas creadas (route_table_id + destination_cidr_block) |
| `route_states` | Mapa de estados de rutas (active, blackhole, etc.) |
| `route_table_ids` | Mapa de IDs de route tables utilizadas |
| `destination_cidr_blocks` | Mapa de CIDRs de destino |

---

## Reglas PC-IAC Aplicadas

| Regla | Descripción | Cumplimiento |
|-------|-------------|--------------|
| PC-IAC-001 | Estructura de 10 archivos raíz + 8 en sample/ | ✅ |
| PC-IAC-002 | Variables con type, description, validation | ✅ |
| PC-IAC-003 | snake_case en HCL, recurso principal `this` | ✅ |
| PC-IAC-004 | Tags: aws_route no soporta tags (limitación AWS) | ✅ Documentado |
| PC-IAC-005 | Provider alias `aws.project` | ✅ |
| PC-IAC-006 | required_version >= 1.0.0, aws >= 4.31.0 | ✅ |
| PC-IAC-007 | Outputs granulares con IDs y estados | ✅ |
| PC-IAC-008 | Sin backend en módulo de referencia | ✅ |
| PC-IAC-009 | optional() en map(object), lógica en locals | ✅ |
| PC-IAC-010 | for_each sobre route_config | ✅ |
| PC-IAC-011 | Sin data sources en módulo de referencia | ✅ |
| PC-IAC-012 | Locals para transformaciones (governance_prefix) | ✅ |
| PC-IAC-023 | Responsabilidad única: solo aws_route | ✅ |
| PC-IAC-025 | Root construye name y lo pasa al módulo | ✅ |
| PC-IAC-026 | sample/ sigue patrón tfvars→variables→locals→main | ✅ |

---

## Arquitectura: Limitación de Tags en aws_route

AWS no permite etiquetar rutas individuales (`aws_route`). Si necesita organizar o identificar rutas, puede:

1. Etiquetar la **route table** (`aws_route_table`) con tags descriptivos.
2. Usar la **clave del mapa** `route_config` como identificador lógico en el estado de Terraform.
3. Documentar las rutas en el `README.md` del Root con la nomenclatura estándar Pragma.

---

## Recursos Relacionados

- [aws_route - Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)
- [aws_route_table - Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)
- [cloudops-ref-repo-aws-networking-terraform](https://github.com/somospragma/cloudops-ref-repo-aws-networking-terraform)
- [cloudops-ref-repo-aws-transit-gateway-terraform](https://github.com/somospragma/cloudops-ref-repo-aws-transit-gateway-terraform)

---

## Mantenimiento

**Equipo:** Chapter CloudOps - Pragma  
**Contacto:** cloudops@pragma.com.co
