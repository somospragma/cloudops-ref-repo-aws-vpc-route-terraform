# Changelog

Todos los cambios notables en este módulo serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es/1.0.0/),
y este proyecto sigue el versionamiento [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2025-01-01

### Added
- Implementación inicial del módulo de referencia para gestión de rutas AWS VPC (`aws_route`).
- Soporte para múltiples tipos de destino: Transit Gateway, NAT Gateway, Internet Gateway, VPC Endpoint, Network Interface, VPC Peering Connection y Core Network (AWS Cloud WAN).
- Variable principal `route_config` de tipo `map(object)` con valores opcionales usando `optional()`.
- Uso de `for_each` sobre `route_config` para estabilidad del estado de Terraform.
- Outputs granulares: `route_ids` y `route_states`.
- Cumplimiento de las 26 reglas PC-IAC de Pragma.
- Directorio `sample/` con ejemplo de caso de uso Hub-Spoke (rutas de retorno en route table del NAT Gateway regional hacia Transit Gateway).
- Soporte para provider alias `aws.project` (PC-IAC-005).

---

## [Unreleased]

- (Pendiente de futuras mejoras)
