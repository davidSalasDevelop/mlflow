# ==============================================================================
# Dockerfile para MLflow Server (VERSIÓN CON PYENV Y SIN RUN.SH)
# ==============================================================================
FROM ghcr.io/mlflow/mlflow:v2.12.2
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    git python3-venv build-essential gosu curl libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget llvm libncurses5-dev \
    xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
ENV PYENV_ROOT "/.pyenv"
ENV PATH "$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
RUN curl https://pyenv.run | bash
RUN pip install --no-cache-dir psycopg2-binary boto3
RUN pip install --no-cache-dir pandas scikit-learn psutil matplotlib seaborn
RUN pip install --no-cache-dir transformers datasets
RUN pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
