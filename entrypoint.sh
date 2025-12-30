#!/bin/sh
# ==============================================================================
# entrypoint.sh (VERSIÓN NUCLEAR DE PERMISOS - CORREGIDA)
# ==============================================================================
# Este script se ejecuta como ROOT al iniciar el contenedor.

set -e # Si algo falla, el script se detiene inmediatamente.

echo "--- [ENTRYPOINT AS ROOT] Iniciando script de arranque nuclear ---"

# --- LA ORDEN DE ANIQUILACIÓN DE PERMISOS ---
if [ -d "/projects" ]; then
    echo "--- [ENTRYPOINT AS ROOT] Encontrada la carpeta /projects. Aniquilando restricciones de permisos... ---"
    
    # chmod 777: Da permisos de LEER, ESCRIBIR y EJECUTAR a TODO EL MUNDO.
    # -R: Recursivamente, a la carpeta y a todo lo que contenga.
    chmod -R 777 /projects
    
    echo "--- [ENTRYPOINT AS ROOT] ¡PERMISOS ANIQUILADOS! La carpeta /projects es ahora zona libre. ---"
else
    echo "--- [ENTRYPOINT AS ROOT] ADVERTENCIA: La carpeta /projects no existe. El volumen no se montó correctamente. ---"
fi

# --- PASAR EL CONTROL AL USUARIO DÉBIL ---
# Después de hacer nuestro trabajo sucio como root, le pasamos el comando original
# al usuario 1001 para que ejecute MLflow de forma segura.
# 'gosu' es una herramienta para cambiar de usuario de forma segura.
# El error estaba aquí, faltaban unas comillas de cierre.
echo "--- [ENTRYPOINT AS ROOT] Permisos arreglados. Pasando el control al usuario 1001 para ejecutar MLflow... ---"
exec gosu 1001 "$@"
