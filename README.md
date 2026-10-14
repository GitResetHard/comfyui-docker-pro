# ComfyUI Docker Pro

Unofficial NVIDIA ComfyUI Docker image using [Comfy-Org/ComfyUI](https://github.com/Comfy-Org/ComfyUI). **Linux Docker + NVIDIA Container Toolkit** are requirements; **ZimaOS is not**.

## Deployment files

| File | Audience | Persistence | Default bind |
|---|---|---|---|
| `docker-compose.yml` | Any NVIDIA-equipped Linux Docker host | Docker named volume `comfy-data` | `127.0.0.1:8188` |
| `docker-compose.zimaos.yml` | ZimaOS | Host path `/DATA/AppData/comfyui` | `0.0.0.0:8188` (trusted LAN) |

These are **independent, complete Compose files**. Pick one. Do **not** combine them using multiple `-f` arguments.

## Standard Docker

```bash
git clone https://github.com/GitResetHard/comfyui-docker-pro.git
cd comfyui-docker-pro
cp .env.example .env
docker compose -f docker-compose.yml up -d --build
docker compose -f docker-compose.yml logs -f comfyui
```

By default, visit `http://127.0.0.1:8188` on the Docker host. To access it over a trusted LAN, set `COMFY_BIND=0.0.0.0` in `.env`. Never expose unauthenticated ComfyUI directly to the public internet.

## ZimaOS

```bash
git clone https://github.com/GitResetHard/comfyui-docker-pro.git
cd comfyui-docker-pro
cp .env.example .env
# Optional: edit .env to change COMFY_DATA, memory limits, port or image version
docker compose -f docker-compose.zimaos.yml up -d --build
docker compose -f docker-compose.zimaos.yml logs -f comfyui
```

The ZimaOS file creates `/DATA/AppData/comfyui` if missing and initializes the expected writable directories. Set `COMFY_DATA` to the actual host filesystem path if different. Existing nested files owned by another UID may still require an administrator permission fix. Default container UID/GID is 1000.

## Images and versioning (NO automatic edge tag)

Both Compose files default to `COMFY_IMAGE=comfyui-docker-pro:local`, built from the checked-out Dockerfile when running `up -d --build`. No GHCR download or moving `edge` tag is required.

Once a versioned image has **actually been published**, set for example `COMFY_IMAGE=ghcr.io/gitresethard/comfyui-docker-pro:v0.1.0`, then run:

```bash
docker compose -f docker-compose.yml pull comfyui
docker compose -f docker-compose.yml up -d --no-build
```

For ZimaOS, replace `docker-compose.yml` with `docker-compose.zimaos.yml`. Prefer an immutable digest for strict repeatability. GitHub Actions only publishes explicit `v*` tags and optionally manual release workflows—not an automatic `edge` tag.

`COMFY_REF=master` is convenient for development builds but tracks upstream. Pin `COMFY_REF` to a tested commit/tag when building a versioned image.

## What is installed

The Dockerfile clones official ComfyUI and installs its `requirements.txt` and `manager_requirements.txt`, FFmpeg, Git, Git LFS and common system libraries. `--enable-manager` is enabled by default.

There is no conflict-free way to preinstall **all** community custom node requirements. Some require incompatible Torch/CUDA/Python versions or additional model downloads. Nodes added through Manager persist as source under `/data/custom_nodes`, but Python packages installed in a running container can be lost on recreation. Reproducible extensions should be installed in a derived/pinned image.

Models are not bundled. Place weights under `/data/models/checkpoints` (or other appropriate `/data/models/*` directories). Outputs, inputs, user settings and caches also persist under `/data`.

## Configuration

Copy `.env.example` to `.env`. Configuration includes `COMFY_IMAGE`, `COMFY_REF`, `COMFY_BIND`, `COMFY_PORT`, `COMFY_DATA` (ZimaOS only), `TZ`, `COMFY_EXTRA_ARGS`, `COMFY_MEM_LIMIT`, `COMFY_MEM_RESERVATION`, `COMFY_SHM_SIZE`, `COMFY_PIDS_LIMIT`, and log rotation limits. RAM settings do not allocate or limit VRAM. `COMFY_EXTRA_ARGS` supports simple whitespace-separated flags without shell interpolation.

## Verify

```bash
# Choose one filename, according to the host:
docker compose -f docker-compose.yml config --quiet
docker compose -f docker-compose.yml ps
docker compose -f docker-compose.yml exec comfyui python -m pip check
docker compose -f docker-compose.yml exec comfyui python -c 'import torch; print("CUDA:", torch.cuda.is_available()); print("GPU:", torch.cuda.get_device_name(0) if torch.cuda.is_available() else "unavailable")'
docker compose -f docker-compose.yml exec comfyui sh -c 'id; test -w /data/output && echo writable'
```

Use `docker-compose.zimaos.yml` instead on ZimaOS. GPU output should show `CUDA: True`. Finally run a real model inference. A CPU GitHub Actions runner cannot verify your NVIDIA hardware.

## Operations

```bash
docker compose -f docker-compose.yml logs --tail=100 comfyui
docker compose -f docker-compose.yml pull
docker compose -f docker-compose.yml up -d --no-build
```

With local builds, use `up -d --build` instead. Back up `/data` before upgrades: for standard Docker, back up the named volume; for ZimaOS back up the host directory configured with `COMFY_DATA`. `restart: unless-stopped` restarts the app after Docker reboots unless manually stopped. A failing health check alone does not restart a container.

## Troubleshooting and security

- **GPU unavailable:** confirm host `nvidia-smi` and the NVIDIA Container Toolkit's Docker integration; `gpus: all` alone does not install drivers.
- **Permission denied:** inspect `docker compose -f <selected-file> logs init-data comfyui`; ensure nested bind-mounted files are writable by UID 1000.
- **Out of memory:** adjust host RAM limits or use smaller workflows; `COMFY_EXTRA_ARGS=--lowvram` can help limited GPUs.
- **Port conflict:** change `COMFY_PORT`.
- **Package conflict:** pin compatible node requirements in your derived image; avoid blanket upgrades.
- **Remote access:** restrict to trusted networks or authenticated TLS reverse proxy. Custom nodes are executable third-party code.

## Verification status

The initial NVIDIA Docker image build and Python smoke tests passed in GitHub Actions. The two updated Compose configurations are validated in CI separately. Actual GPU execution, custom-node functionality, persistency and reboot behavior require tests on your host.

See [LICENSE-NOTICE.md](LICENSE-NOTICE.md). Not affiliated with Comfy-Org.
