# Usamos la imagen oficial de MLflow como base
FROM ghcr.io/mlflow/mlflow:v2.12.2

# Cambiamos al usuario root para poder instalar paquetes del sistema
USER root

# Instalamos las herramientas que le faltan al Chef:
# - python3-venv: Para que pueda crear entornos virtuales para los proyectos.
# - build-essential: Necesario para compilar algunas librerías de Python.
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-venv \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Ahora, instalamos las librerías de Python que necesita el servidor:
# - psycopg2-binary: Para hablar con tu base de datos PostgreSQL.
# - boto3: Para hablar con tu almacén MinIO.
RUN pip install --no-cache-dir psycopg2-binary boto3

# Devolvemos el control al usuario por defecto de la imagen de MLflow
USER 1001
