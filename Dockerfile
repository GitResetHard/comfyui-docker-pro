# syntax=docker/dockerfile:1.7
ARG PYTORCH_IMAGE=pytorch/pytorch:2.8.0-cuda12.8-cudnn9-runtime
FROM ${PYTORCH_IMAGE}
ARG COMFY_REF=v0.40.0
ENV DEBIAN_FRONTEND=noninteractive PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 PIP_NO_CACHE_DIR=1 HF_HOME=/data/cache/huggingface XDG_CACHE_HOME=/data/cache/xdg TORCH_HOME=/data/cache/torch MPLCONFIGDIR=/data/cache/matplotlib
RUN apt-get update && apt-get install -y --no-install-recommends git git-lfs ffmpeg libgl1 libglib2.0-0 libgomp1 ca-certificates tini curl gosu && rm -rf /var/lib/apt/lists/*
WORKDIR /opt/ComfyUI
RUN git clone --filter=blob:none https://github.com/Comfy-Org/ComfyUI.git . && git checkout "$COMFY_REF" && git lfs install --skip-repo && python -m pip install --upgrade pip setuptools wheel && python -m pip install -r requirements.txt -r manager_requirements.txt && python -m pip check && python -c 'import torch; import aiohttp; print("Torch", torch.__version__)'
RUN useradd --create-home --uid 1000 --shell /bin/bash comfy && install -d -o comfy -g comfy /data /data/cache && chown -R comfy:comfy /opt/ComfyUI
COPY --chmod=755 scripts/entrypoint.sh /usr/local/bin/comfy-entrypoint
ENV HOME=/home/comfy
EXPOSE 8188
VOLUME ["/data"]
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/comfy-entrypoint"]
CMD ["python","main.py","--listen","0.0.0.0","--port","8188","--base-directory","/data","--enable-manager"]
HEALTHCHECK --interval=30s --timeout=10s --start-period=180s --retries=5 CMD python -c 'import urllib.request; urllib.request.urlopen("http://127.0.0.1:8188/system_stats",timeout=8)' || exit 1
