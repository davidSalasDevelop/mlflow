#!/bin/sh
# ==============================================================================
# entrypoint.sh
# ==============================================================================
# Este script se ejecuta al iniciar el contenedor 'mlflow-server'.

# 1. Mensaje de inicio para depuración.
echo "--- [ENTRYPOINT] Iniciando script de arranque ---"

# 2. Arreglar permisos en la carpeta de proyectos.
#    Esto es crucial para que el usuario sin privilegios de MLflow pueda
#    leer el código y escribir en las carpetas temporales.
if [ -d "/projects" ]; then
    echo "--- [ENTRYPOINT] Dando permisos a la carpeta /projects... ---"
    # Cambia el propietario de la carpeta al usuario '1001' que usa MLflow.
    chown -R 1001:1001 /projects
    # Da permisos de lectura, escritura y ejecución al propietario y al grupo.
    chmod -R 775 /projects
    echo "--- [ENTRYPOINT] Permisos aplicados. ---"
else
    echo "--- [ENTRYPOINT] ADVERTENCIA: La carpeta /projects no existe. El volumen no se montó correctamente. ---"
fi

# 3. Iniciar el comando principal de MLflow.
#    El 'exec "$@"' ejecuta el comando que le pasamos desde 'docker-compose.yml'.
echo "--- [ENTRYPOINT] Iniciando el comando principal del servidor MLflow... ---"
exec "$@"
