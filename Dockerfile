# ==============================================================================
# Dockerfile para MLflow Server (VERSIÓN VICTORIA FINAL)
# ==============================================================================

# 1. Usar la imagen oficial de MLflow como base.
FROM ghcr.io/mlflow/mlflow:v2.12.2

# 2. Cambiar a usuario 'root' para instalar todo.
USER root

# 3. Instalar las herramientas de sistema.
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3-venv \
    build-essential \
    gosu \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 4. ¡¡LA PARTE CLAVE!! Instalar TODAS las librerías de Python de una vez.
#    Instalamos tanto las del servidor como las del entrenamiento.
RUN pip install --no-cache-dir \
    psycopg2-binary \
    boto3 \
    transformers \
    datasets \
    scikit-learn \
    psutil \
    matplotlib \
    seaborn \
    pandas \
    torch --index-url https://download.pytorch.org/whl/cpu

# 5. Copiar y preparar el script de arranque/permisos.
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 6. Definir nuestro script como el punto de entrada.
ENTRYPOINT ["/entrypoint.sh"]

# NO CAMBIAMOS DE USUARIO AQUÍ. El entrypoint se encarga de eso.
