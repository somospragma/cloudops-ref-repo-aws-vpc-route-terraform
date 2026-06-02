# Ejemplo de Uso: cloudops-ref-repo-aws-vpc-route-terraform

Este directorio contiene un ejemplo funcional del módulo de rutas VPC, implementando un escenario **Hub-Spoke con Transit Gateway**.

## Escenario

- **Hub:** VPC central con NAT Gateways compartidos.
- **Spokes:** VPCs de proyecto que enrutan su tráfico de salida a Internet a través del Hub.
- **Rutas de retorno:** Rutas en las route tables de los NAT Gateways para reenviar tráfico de regreso a los Spokes vía Transit Gateway.
- **Rutas en Spokes:** Ruta `0.0.0.0/0` al NAT GW y ruta `10.0.0.0/8` al Transit Gateway.

## Flujo de Datos (PC-IAC-026)

```
terraform.tfvars → variables.tf → data.tf → locals.tf → main.tf → ../
     (config)        (tipos)     (consulta)  (transform)  (invoca módulo)
```

## Pre-requisitos

Antes de ejecutar este ejemplo, asegúrese de tener desplegado:
1. Una VPC Hub con NAT Gateways y sus route tables.
2. Un Transit Gateway con attachments a las VPCs spoke.
3. VPCs Spoke con sus route tables privadas.
4. Los recursos deben estar etiquetados siguiendo la nomenclatura Pragma estándar.

## Ejecución

```bash
cd sample/

# 1. Inicializar el estado local
terraform init

# 2. Revisar el plan
terraform plan -var-file="terraform.tfvars"

# 3. Aplicar (solo en desarrollo)
terraform apply -var-file="terraform.tfvars"

# 4. Destruir al terminar las pruebas
terraform destroy -var-file="terraform.tfvars"
```

## Variables Requeridas

Edite el archivo `terraform.tfvars` con los valores de su ambiente antes de ejecutar.

## Nota sobre IDs Dinámicos

Los IDs de route tables, Transit Gateway y NAT Gateway se obtienen automáticamente
desde Data Sources usando la nomenclatura estándar Pragma. No es necesario
hardcodear IDs en `terraform.tfvars` (PC-IAC-026).
