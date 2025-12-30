# ==============================================================================
# Dockerfile para MLflow Server (VERSIÓN NUCLEAR DE PERMISOS)
# ==============================================================================

# 1. Usar la imagen oficial de MLflow como base.
FROM ghcr.io/mlflow/mlflow:v2.12.2

# 2. Cambiar a usuario 'root' y QUEDARSE COMO ROOT para que el entrypoint tenga poder.
USER root

# 3. Instalar TODAS las herramientas, incluyendo 'gosu', nuestro cambiador de usuario.
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3-venv \
    build-essential \
    gosu \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 4. Instalar las librerías de Python que el servidor necesita.
RUN pip install --no-cache-dir \
    psycopg2-binary \
    boto3

# 5. Copiar el script de arranque/permisos al contenedor.
COPY entrypoint.sh /entrypoint.sh

# 6. Hacer que el script sea ejecutable.
RUN chmod +x /entrypoint.sh

# 7. Definir nuestro script como el punto de entrada.
#    Como no hemos cambiado de usuario, se ejecutará como ROOT.
ENTRYPOINT ["/entrypoint.sh"]

# NO CAMBIAMOS DE USUARIO AQUÍ. El entrypoint se encarga de eso.
# USER 1001
