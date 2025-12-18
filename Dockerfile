# ==================================================================================
# Dockerfile para la imagen personalizada de MLflow
# ==================================================================================

# Usamos la imagen oficial de MLflow como base
FROM ghcr.io/mlflow/mlflow:v2.12.2

# Instalamos el conector para que pueda hablar con la base de datos PostgreSQL
RUN pip install psycopg2-binary
