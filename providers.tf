# Configuración de providers (PC-IAC-005)
# El provider se inyecta desde el Módulo Raíz mediante el alias aws.project
# No se declara configuración de provider aquí - se recibe del consumidor
# El alias aws.project debe ser pasado desde el Módulo Raíz (IaC Root) que
# declara el provider con alias = "principal" y lo mapea a aws.project en el
# bloque providers del módulo.
