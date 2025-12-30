#!/bin/sh

# Este script se ejecuta al iniciar el contenedor 'mlflow-server'.

# 1. Mensaje de inicio
echo "--- Iniciando script entrypoint.sh ---"

# 2. Arreglar permisos (si la carpeta de proyectos existe)
#    Le damos permisos totales a la carpeta que montaremos como volumen.
#    Esto asegura que el usuario 'mlflow' dentro del contenedor pueda leer y escribir.
if [ -d "/projects" ]; then
    echo "Dando permisos a la carpeta /projects..."
    chown -R 1001:1001 /projects
    chmod -R 775 /projects
    echo "Permisos aplicados."
fi

# 3. Iniciar el servidor MLflow
#    El 'exec "$@"' ejecuta el comando que le pasamos desde docker-compose.yml
echo "Iniciando el comando principal de MLflow..."
exec "$@"
