# ComfyUI Docker Pro

An **unofficial** NVIDIA Docker distribution based on [Comfy-Org/ComfyUI](https://github.com/Comfy-Org/ComfyUI). Installs the upstream frontend, workflow templates, and Manager dependencies at build time instead of downloading a frontend release every startup.

## Features

- NVIDIA GPU support (Linux amd64 with compatible driver and NVIDIA Container Toolkit)
- Official upstream `requirements.txt` and `manager_requirements.txt`
- Built-in ComfyUI-Manager with `--enable-manager`
- FFmpeg, Git, Git LFS, OpenGL runtime dependencies
- Persistent models, custom nodes, input, output, user data, and caches under `/data`
- Non-root UID 1000, `tini`, health check, Compose, GitHub Actions validation and GHCR publishing

**Limits:** No image can bundle every custom node or model dependency. Some packages conflict or require proprietary files. AMD and Intel images need separate GPU stacks and are not provided yet.

## Quick start

```bash
git clone https://github.com/GitResetHard/comfyui-docker-pro.git
cd comfyui-docker-pro
cp .env.example .env
# On ZimaOS, edit .env: COMFY_DATA=/DATA/AppData/comfyui
docker compose build
docker compose up -d
docker compose logs -f comfyui
```

Open `http://YOUR_HOST_IP:8188` on a **trusted LAN**. ComfyUI doesn't enable authentication by default. Do not expose port 8188 directly to the public internet.

## Permissions

The container runs as UID 1000. Ensure the directory configured by `COMFY_DATA` is writable by UID 1000. For a local data folder:

```bash
mkdir -p data
sudo chown -R 1000:1000 data
```

## Models and GPU limits

Models are not bundled. Put checkpoints in `/data/models/checkpoints`, LoRAs under `/data/models/loras`, and so forth. The NVIDIA driver and container runtime must support the CUDA image. VRAM determines which models fit.

## Pin and upgrade ComfyUI

The default `COMFY_REF=master` tracks upstream and isn't reproducible. Pin a tested tag or commit in `.env` and rebuild:

```bash
docker compose build --pull --no-cache
docker compose up -d
```

Back up `/data` first. Upgrading ComfyUI may break custom nodes or their dependencies.

## Validate

```bash
docker compose --env-file .env.example config -q
bash -n scripts/entrypoint.sh
docker compose build
docker compose up -d
docker compose ps
docker exec comfyui python -c 'import torch; print(torch.cuda.is_available())'
```

The CUDA check should return `True` on a correctly configured NVIDIA GPU. CI builds do not replace a hardware GPU smoke test.

## GHCR

Pushing a `v*` tag triggers a build/push workflow for `ghcr.io/gitresethard/comfyui-docker-pro:<tag>`. This only becomes available after a successful workflow run.

## Troubleshooting

- Permission denied: ensure UID 1000 can write to the data mount.
- Missing NVIDIA GPU: verify host driver and NVIDIA Container Toolkit.
- Out of memory: use a smaller model or reduce workflow VRAM requirements.
- Missing custom-node module: follow the node author's dependency instructions.

See [LICENSE-NOTICE.md](LICENSE-NOTICE.md). Not affiliated with Comfy-Org.
