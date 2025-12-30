#!/bin/bash
# ==============================================================================
# run.sh - La Caja Negra de Logs
# ==============================================================================
# Este script envuelve el comando principal para capturar todos los logs.

# Si algo falla, el script se detendrá inmediatamente.
set -e

# --- LA TRAMPA MORTAL ---
# Esto es lo más importante. 'trap' le dice a bash: "Si este script termina,
# ya sea por éxito o por un error catastrófico (EXIT), ejecuta la función 'cleanup'".
cleanup() {
  echo "--- [Caja Negra] El proceso ha terminado. Subiendo logs a MLflow... ---"
  # Usamos el CLI de MLflow para subir el fichero de log como un artefacto.
  # Esto se ejecutará incluso si el 'pip install' explota.
  mlflow log-artifact execution.log
}
trap cleanup EXIT


# --- EL GRABADOR ---
# 'exec "$@"' ejecuta el comando que le pasamos desde MLProject (ej. 'python train.py ...')
# Redirigimos tanto la salida estándar (stdout) como la de errores (stderr)
# a la consola Y al fichero 'execution.log' usando 'tee'.
echo "--- [Caja Negra] Iniciando la grabación. El comando es: $@ ---"
exec "$@" > >(tee -a execution.log) 2> >(tee -a execution.log >&2)
