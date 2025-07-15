#!/bin/bash

source /opt/conda/etc/profile.d/conda.sh
conda activate remote_jupyter_env

CMD=(
  jupyter notebook
  --ip=0.0.0.0
  --port=8888
  --no-browser
  --allow-root
  --NotebookApp.token="${JUPYTER_TOKEN:-''}"
)

if [ -n "$JUPYTER_RAW_PASSWORD" ]; then
    HASHED_PASSWORD=$(python -c "from jupyter_server.auth import passwd; print(passwd('$JUPYTER_RAW_PASSWORD'))")
    CMD+=(--NotebookApp.password="$HASHED_PASSWORD")
fi

echo "Starting Jupyter Notebook..."
echo "Token: $JUPYTER_TOKEN"
echo "Password: ${JUPYTER_RAW_PASSWORD:+[hidden]}"

exec "${CMD[@]}"
