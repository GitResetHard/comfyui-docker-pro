# ComfyUI Docker Pro

Docker image for [ComfyUI](https://github.com/Comfy-Org/ComfyUI) with NVIDIA GPU support and the built-in ComfyUI Manager.

**ZimaOS:** [Installation guide](ZIMAOS.md).

## Docker Compose (Linux)

Requires Docker Engine, Docker Compose, an NVIDIA GPU, and NVIDIA Container Toolkit.

```bash
git clone https://github.com/GitResetHard/comfyui-docker-pro.git
cd comfyui-docker-pro
cp .env.example .env
docker compose up -d --build
```

Open **http://localhost:8188**.

To access ComfyUI from another device, set `COMFY_BIND=0.0.0.0` in `.env` and rebuild/recreate the container. Only expose it on trusted networks.

## Configuration

Edit `.env` before running Docker Compose:

| Setting | Purpose |
| --- | --- |
| `COMFY_REF` | ComfyUI release tag used for builds (pinned to `v0.40.0` by default) |
| `COMFY_PORT` | Web interface port (default `8188`) |
| `COMFY_BIND` | Host interface (default `127.0.0.1`) |
| `COMFY_MEM_LIMIT` | Container memory limit |
| `COMFY_EXTRA_ARGS` | Optional ComfyUI startup flags |

For the legacy Manager interface, set `COMFY_EXTRA_ARGS=--enable-manager-legacy-ui`. The regular Manager is already enabled.

## Storage and updates

Models, custom nodes, inputs, outputs, and settings persist in the Docker volume `comfy-data`. Rebuilding the image does not remove the volume. Model weights are not included.

Back up your data before upgrading.

## Troubleshooting

```bash
docker compose logs -f comfyui
docker compose ps
```

If GPU acceleration is unavailable, verify the NVIDIA driver and NVIDIA Container Toolkit on the host.

ComfyUI does not include authentication by default. Do not expose port `8188` directly to the public internet.

[ZimaOS guide](ZIMAOS.md) · [License notices](LICENSE-NOTICE.md)
