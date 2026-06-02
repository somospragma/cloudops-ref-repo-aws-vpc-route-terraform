# Data sources del ejemplo (PC-IAC-026)
# Consulta de recursos existentes para inyectar IDs dinámicos en locals.tf

############################################################################
# Transit Gateway - Hub regional
############################################################################

data "aws_ec2_transit_gateway" "hub" {
  provider = aws.principal

  filter {
    name   = "tag:Name"
    values = ["${var.client}-${var.project}-${var.environment}-tgw"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

############################################################################
# NAT Gateways del Hub (para rutas de retorno)
############################################################################

data "aws_nat_gateway" "hub_az1" {
  provider = aws.principal

  filter {
    name   = "tag:Name"
    values = ["${var.client}-${var.project}-${var.environment}-nat-az1"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

############################################################################
# Route Tables del Hub - route tables asociadas a los NAT Gateways
# (donde se crean las rutas de retorno hacia los Spokes vía TGW)
############################################################################

data "aws_route_table" "hub_nat_az1" {
  provider = aws.principal

  filter {
    name   = "tag:Name"
    values = ["${var.client}-${var.project}-${var.environment}-rt-nat-az1"]
  }
}

############################################################################
# Route Tables de las subnets privadas del Spoke
############################################################################

data "aws_route_table" "spoke_private" {
  provider = aws.principal

  filter {
    name   = "tag:Name"
    values = ["${var.client}-${var.project}-${var.environment}-rt-private"]
  }
}
