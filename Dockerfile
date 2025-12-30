# Usamos la imagen oficial de MLflow como base
FROM ghcr.io/mlflow/mlflow:v2.12.2

# Cambiamos al usuario root para poder instalar software y cambiar permisos
USER root

# 1. Instalamos las herramientas del sistema que faltan
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3-venv \
    build-essential \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Instalamos las librerías de Python que el servidor necesita
RUN pip install --no-cache-dir \
    psycopg2-binary \
    boto3

# 3. ¡LA PARTE NUEVA! Copiamos nuestro script de permisos al contenedor
COPY entrypoint.sh /entrypoint.sh

# 4. Hacemos que el script sea ejecutable
RUN chmod +x /entrypoint.sh

# 5. Devolvemos el control al usuario por defecto de MLflow
USER 1001

# 6. ¡LA PARTE NUEVA! Definimos que nuestro script es el punto de entrada
ENTRYPOINT ["/entrypoint.sh"]
