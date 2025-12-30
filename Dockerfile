# ==============================================================================
# Dockerfile para MLflow Server (VERSIÓN CIRUJANO A PRUEBA DE BALAS)
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

# 4. ¡¡LA PARTE CLAVE!! Instalar las librerías de Python en bloques separados.
#    Si una falla, sabremos exactamente cuál es.

# --- BLOQUE 1: Dependencias del Servidor ---
RUN pip install --no-cache-dir \
    psycopg2-binary \
    boto3

# --- BLOQUE 2: Dependencias de Data Science y Métricas ---
RUN pip install --no-cache-dir \
    pandas \
    scikit-learn \
    psutil \
    matplotlib \
    seaborn

# --- BLOQUE 3: Dependencias de NLP (Hugging Face) ---
RUN pip install --no-cache-dir \
    transformers \
    datasets

# --- BLOQUE 4: La Puta Bestia (PyTorch) ---
# La aislamos porque es la más propensa a fallar.
RUN pip install --no-cache-dir \
    torch --index-url https://download.pytorch.org/whl/cpu

# 5. Copiar y preparar el script de arranque/permisos.
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 5.2 Hacer que los scripts sean ejecutables.
COPY run.sh /run.sh
RUN chmod +x /entrypoint.sh /run.sh

# 6. Definir nuestro script como el punto de entrada.
ENTRYPOINT ["/entrypoint.sh"]

# NO CAMBIAMOS DE USUARIO AQUÍ. El entrypoint se encarga de eso.
