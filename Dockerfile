# ==============================================================================
# Dockerfile para crear una imagen de MLflow Server robusta y lista para producción.
# ==============================================================================

# 1. Usamos la imagen oficial de MLflow como punto de partida.
#    Esto nos da Python y MLflow ya instalados y configurados.
FROM ghcr.io/mlflow/mlflow:v2.12.2

# 2. Cambiamos temporalmente al usuario 'root' para poder instalar software del sistema.
#    La imagen base de MLflow se ejecuta como un usuario sin privilegios por seguridad.
USER root

# 3. Instalamos las herramientas del sistema operativo que le faltan a la imagen base.
#    - git: ¡EL CULPABLE! Necesario para que MLflow pueda clonar proyectos desde repositorios de Git.
#    - python3-venv: La herramienta estándar de Python para crear entornos virtuales. MLflow la necesita para los `python_env`.
#    - build-essential: Un conjunto de paquetes (como compiladores de C++) que a veces son necesarios
#      para instalar librerías de Python complejas desde `pip`.
#    El comando `apt-get clean && rm -rf /var/lib/apt/lists/*` es una buena práctica para mantener la imagen pequeña.
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3-venv \
    build-essential \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 4. Instalamos las librerías de Python adicionales que el PROPIO SERVIDOR de MLflow necesita
#    para funcionar con tu configuración específica.
#    - psycopg2-binary: El "driver" para que MLflow pueda hablar con tu base de datos PostgreSQL.
#    - boto3: El "driver" para que MLflow pueda hablar con tu almacén de artefactos MinIO (que usa la API de S3).
#    `--no-cache-dir` ayuda a mantener la imagen un poco más pequeña.
RUN pip install --no-cache-dir \
    psycopg2-binary \
    boto3

# 5. Devolvemos el control al usuario por defecto sin privilegios de la imagen de MLflow.
#    Esto es una buena práctica de seguridad, para que el servidor no se ejecute como root.
#    El ID de usuario 1001 es el que usa la imagen base de MLflow.
USER 1001
