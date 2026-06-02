# Valores de variables para el ejemplo (PC-IAC-026)
# Configuración declarativa sin IDs hardcodeados de recursos AWS.
# Los IDs se obtienen automáticamente desde data sources en locals.tf.

client      = "pragma"
project     = "networking"
environment = "dev"
region      = "us-east-1"

# Configuración de rutas - escenario Hub-Spoke con Transit Gateway
#
# Rutas de RETORNO en la route table del NAT Gateway del Hub:
# El tráfico que llega del TGW con destino a los Spokes necesita
# rutas de retorno para volver al TGW desde el NAT GW.
#
# Rutas en las subnets PRIVADAS del Spoke:
# - 0.0.0.0/0 → NAT Gateway del Hub (via TGW)
# - 10.0.0.0/8 → Transit Gateway (para tráfico inter-spoke y on-premises)
#
# Los campos vacíos ("") o con use_*_from_data=true se llenan automáticamente
# desde data sources en locals.tf (PC-IAC-026).

route_config = {

  # ── Rutas de retorno en la RT del NAT GW del Hub (az1) ──────────────────
  # Permite que el tráfico de los Spokes que pasa por el NAT GW regrese al TGW

  "retorno-spoke-desarrollo" = {
    destination_cidr_block = "10.34.0.0/16"  # CIDR del spoke de desarrollo
    route_table_id         = ""               # Se llenará desde data source (hub_nat_az1)
    transit_gateway_id     = ""               # Se llenará desde data source TGW
    use_rt_from_data       = "hub_nat_az1"
    use_tgw_from_data      = true
  }

  "retorno-spoke-produccion" = {
    destination_cidr_block = "10.35.0.0/16"  # CIDR del spoke de producción
    route_table_id         = ""
    transit_gateway_id     = ""
    use_rt_from_data       = "hub_nat_az1"
    use_tgw_from_data      = true
  }

  "retorno-on-premises" = {
    destination_cidr_block = "172.16.0.0/12"  # CIDR de red on-premises
    route_table_id         = ""
    transit_gateway_id     = ""
    use_rt_from_data       = "hub_nat_az1"
    use_tgw_from_data      = true
  }

  # ── Rutas en la RT privada del Spoke ────────────────────────────────────

  "default-salida-internet" = {
    destination_cidr_block = "0.0.0.0/0"     # Tráfico de salida a Internet
    route_table_id         = ""               # Se llenará desde data source (spoke_private)
    nat_gateway_id         = ""               # Se llenará desde data source (NAT GW Hub)
    use_rt_from_data       = "spoke_private"
    use_nat_from_data      = true
  }

  "privado-hacia-tgw" = {
    destination_cidr_block = "10.0.0.0/8"    # Todo el espacio RFC-1918 clase A
    route_table_id         = ""
    transit_gateway_id     = ""
    use_rt_from_data       = "spoke_private"
    use_tgw_from_data      = true
  }
}
