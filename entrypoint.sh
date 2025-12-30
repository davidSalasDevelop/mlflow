#!/bin/sh
# ==============================================================================
# entrypoint.sh (VERSIÓN NUCLEAR DE PERMISOS)
# ==============================================================================
# Este script se ejecuta como ROOT al iniciar el contenedor.

set -e # Si algo falla, el script se detiene inmediatamente.

echo "--- [ENTRYPOINT AS ROOT] Iniciando script de arranque nuclear ---"

# --- LA ORDEN DE ANIQUILACIÓN DE PERMISOS ---
# Comprobamos si la carpeta de la ventana existe.
if [ -d "/projects" ]; then
    echo "--- [ENTRYPOINT AS ROOT] Encontrada la carpeta /projects. Aniquilando restricciones de permisos... ---"
    
    # chmod 777: Da permisos de LEER, ESCRIBIR y EJECUTAR a TODO EL MUNDO (dueño, grupo, otros).
    # -R: Recursivamente, a la carpeta y a todo lo que contenga en el futuro.
    chmod -R 777 /projects
    
    echo "--- [ENTRYPOINT AS ROOT] ¡PERMISOS ANIQUILADOS! La carpeta /projects es ahora zona libre. ---"
else
    echo "--- [ENTRYPOINT AS ROOT] ADVERTENCIA: La carpeta /projects no existe. El volumen no se montó correctamente. -"
