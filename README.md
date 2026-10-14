# ComfyUI Docker Pro

Unofficial ComfyUI NVIDIA container based on [Comfy-Org/ComfyUI](https://github.com/Comfy-Org/ComfyUI), designed for ZimaOS and modern Docker Compose.

> **Status:** The previous NVIDIA CI image build completed successfully. The ZimaOS-specific Compose deployment and GPU passthrough need testing on real hardware. **Do not expose this deployment directly to the internet.** ComfyUI does not offer authentication by default.

## Requirements

- ZimaOS on a Linux x86-64 host with an NVIDIA GPU and driver compatible with the CUDA runtime in the [Dockerfile](Dockerfile)
- Docker Engine with NVIDIA Container Toolkit installed and GPU access enabled
- Docker Compose v2 with `gpus: all` and `depends_on: condition: service_completed_successfully` support
- Enough free disk for the large CUDA image, models, generated media, and caches
- Adequate host RAM; default limit 12 GiB, reservation 4 GiB (adjust for your machine)

Check GPU availability on the **host** first:

```bash
nvidia-smi
docker info --format '{{json .Runtimes}}'
```

A working host GPU does not automatically mean Docker GPU passthrough works. Once deployed, perform the container test below.

## ZimaOS quick start

Connect over SSH:

```bash
git clone https://github.com/GitResetHard/comfyui-docker-pro.git
cd comfyui-docker-pro
cp .env.example .env
nano .env
```

Set `COMFY_DATA=/DATA/AppData/comfyui` (the default) if the ZimaOS AppData partition is at `/DATA`. Set `COMFY_MEM_LIMIT` and `COMFY_MEM_RESERVATION` for your physical RAM.

Run:

```bash
docker compose -f docker-compose.yml up -d
docker compose -f docker-compose.yml ps
docker compose -f docker-compose.yml logs -f comfyui
```

Open `http://YOUR-ZIMAOS-IP:8188`. The default binds to all host IPv4 interfaces for use from your trusted LAN. ZimaOS custom-app importers may display a separate app tile, but this repository is deliberately standard Compose, not a CasaOS app-store manifest.

### Local build versus published image

By default Compose uses `COMFY_IMAGE=ghcr.io/gitresethard/comfyui-docker-pro:edge`. The `edge` tag must exist in GHCR and be public for pulling to work. To compile the local Dockerfile yourself:

```bash
docker compose -f docker-compose.yml up -d --build
```

For an immutable deployment, replace `COMFY_IMAGE` with a tested release tag or SHA256 digest instead of the moving `edge` tag.

### Persistent layout

Everything is stored under the existing `COMFY_DATA` directory:

| Host | Inside container |
| --- | --- |
| `/DATA/AppData/comfyui/models` | `/data/models` |
| `/DATA/AppData/comfyui/custom_nodes` | `/data/custom_nodes` |
| `/DATA/AppData/comfyui/input` | `/data/input` |
| `/DATA/AppData/comfyui/output` | `/data/output` |
| `/DATA/AppData/comfyui/user` | `/data/user` |
| `/DATA/AppData/comfyui/cache` | `/data/cache` |

The **init-data** service creates the top-level directory and standard writable subdirectories, assigning those directory owners to container UID/GID 1000. It intentionally does **not** recursively chown existing model files. Existing files and nested folders with different permissions may need a one-time administrator fix. Data survives container recreation and host reboot.

Models are *not* bundled. Drop `.safetensors` checkpoints into `models/checkpoints`, LoRAs into `models/loras`, and other weights into their corresponding model directories.

### Environment variables

Copy `.env.example` to `.env` and edit values:

| Variable | Default | Meaning |
| --- | --- | --- |
| `COMFY_DATA` | `/DATA/AppData/comfyui` | Persistent host bind-mount root |
| `COMFY_IMAGE` | `ghcr.io/gitresethard/comfyui-docker-pro:edge` | Published image name/tag or local build output |
| `COMFY_REF` | `master` | Upstream ComfyUI ref for local builds (pin a tested commit in production) |
| `COMFY_BIND` | `0.0.0.0` | Host listen address; set to `127.0.0.1` when using local reverse proxy |
| `COMFY_PORT` | `8188` | Host port |
| `TZ` | `Europe/Istanbul` | Container timezone |
| `COMFY_MEM_LIMIT` | `12g` | Host RAM ceiling, not GPU VRAM |
| `COMFY_MEM_RESERVATION` | `4g` | Soft RAM reservation |
| `COMFY_SHM_SIZE` | `1gb` | Shared-memory size |
| `COMFY_PIDS_LIMIT` | `1024` | PID limit |
| `COMFY_EXTRA_ARGS` | empty | Optional ComfyUI CLI arguments, separated by whitespace |
| `COMFY_LOG_MAX_SIZE` | `20m` | Max size per log file |
| `COMFY_LOG_MAX_FILES` | `5` | Rotated log files to retain |

The image sets `--listen 0.0.0.0 --port 8188 --base-directory /data --enable-manager` by default. `COMFY_EXTRA_ARGS` is split on whitespace; do not use shell quoting or shell expressions.

### Check GPU, health and permissions

```bash
docker compose -f docker-compose.yml config --quiet
docker compose -f docker-compose.yml ps
docker compose -f docker-compose.yml logs --tail=150 comfyui
docker compose -f docker-compose.yml exec comfyui python -c 'import torch; print("CUDA:", torch.cuda.is_available()); print("GPU:", torch.cuda.get_device_name(0) if torch.cuda.is_available() else "unavailable")'
docker compose -f docker-compose.yml exec comfyui python -m pip check
docker compose -f docker-compose.yml exec comfyui sh -c 'id && test -w /data/output && test -w /data/custom_nodes && echo "storage writable"'
```

The GPU command must report `CUDA: True` and your NVIDIA card. Finally, load a model and run an actual generation workflow. CI on a GitHub-hosted CPU runner is **not** proof of GPU inference.

### Custom nodes and dependency policy

The image installs ComfyUI's upstream `requirements.txt` and `manager_requirements.txt`, plus Git, Git LFS, FFmpeg and common system libraries. It does **not** preinstall every node from the community: many nodes require mutually incompatible Torch/CUDA/Python versions or downloads of additional proprietary weights. Install nodes via ComfyUI-Manager and read each node's compatibility instructions.

Custom node **source directories** persist in `/data/custom_nodes`. Python packages installed interactively inside a container can be lost when it is replaced. For reproducible deployments, extend the image in a derived Dockerfile and pin the node dependency versions, then rebuild. Avoid indiscriminate `pip install -U` against the running environment.

### Updates, restart and backup

```bash
git pull --ff-only
docker compose -f docker-compose.yml pull
docker compose -f docker-compose.yml up -d
docker compose -f docker-compose.yml ps
```

For locally built images, use `docker compose -f docker-compose.yml up -d --build`. Backup `COMFY_DATA` before updating. Image upgrades may change ComfyUI internals, torch or node APIs; pin known-good image tags rather than blindly upgrading in production.

`restart: unless-stopped` restarts the app after Docker and host reboot unless you manually stop it. The one-shot initializer has `restart: "no"` and must complete successfully before ComfyUI starts. The health check reports unhealthy state; Docker Compose **does not automatically restart containers solely because they are unhealthy**.

### Troubleshooting

- **Container won't start / permission denied:** `docker compose -f docker-compose.yml logs init-data comfyui`. Check `ls -ld /DATA/AppData/comfyui` and nested directories. UID 1000 needs write access.
- **GPU not available:** inspect `nvidia-smi`, `docker info` and Docker GPU integration on ZimaOS; the Compose request alone cannot install drivers or the container toolkit.
- **CUDA out of memory:** use a smaller model, lower resolution, or `COMFY_EXTRA_ARGS=--lowvram`.
- **Host out of memory / exit 137:** raise `COMFY_MEM_LIMIT` if RAM allows, or reduce workload.
- **Manager package conflicts:** review the failing node's requirements; derive a dedicated image instead of modifying the base unpredictably.
- **GHCR package inaccessible:** verify the image was published and made public, or use `--build`.
- **Port in use:** change `COMFY_PORT`.

### Security and maintenance

ComfyUI custom nodes are executable code; only install sources you trust. The container drops Linux capabilities, uses `no-new-privileges`, a non-root application process, a private bridge network, and bounded logs. The initializer temporarily runs as root with only the capabilities needed to create and chown the data directories. No passwords are embedded; secure external access needs an authenticated reverse proxy plus TLS and preferably network access restrictions. Monitor disk growth under `output` and `cache`.

## CI and release status

GitHub Actions validates the Compose file, Bash syntax and startup contract, and builds the NVIDIA image. A CPU-only startup/dependency smoke test runs before publication. Real ZimaOS NVIDIA integration, custom-node compatibility and heavy model generation remain hardware acceptance checks.

See [LICENSE-NOTICE.md](LICENSE-NOTICE.md). This project is unofficial and not affiliated with Comfy-Org.
