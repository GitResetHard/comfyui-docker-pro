# ComfyUI Docker Pro

Docker image for [ComfyUI](https://github.com/Comfy-Org/ComfyUI) with NVIDIA GPU support and the built-in ComfyUI Manager.

**ZimaOS:** [Installation guide](ZIMAOS.md).

## Docker Compose (Linux)

Requires Docker Engine, Docker Compose, an NVIDIA GPU, and NVIDIA Container Toolkit.

```bash
git clone https://github.com/GitResetHard/comfyui-docker-pro.git
cd comfyui-docker-pro
docker compose up -d
```

Open **http://localhost:8188**.

To access ComfyUI from another device, change the host binding in `docker-compose.yml` to `0.0.0.0` and recreate the container. Only expose it on trusted networks.

## Configuration

Optional settings can be changed in `docker-compose.yml` or supplied through a `.env` file:

| Setting | Purpose |
| --- | --- |
| `COMFY_PORT` | Web interface port (default `8188`) |
| `COMFY_BIND` | Host interface (default `127.0.0.1`) |
| `COMFY_MEM_LIMIT` | Container memory limit |
| `COMFY_EXTRA_ARGS` | Optional ComfyUI startup flags |

For the legacy Manager interface, set `COMFY_EXTRA_ARGS=--enable-manager-legacy-ui` in `.env` or as a Compose environment variable. The regular Manager is already enabled.

## Storage and updates

Models, custom nodes, inputs, outputs, and settings persist in the Docker volume `comfy-data`. Recreating the container does not remove the volume. Model weights are not included.

To upgrade, change the image tag in `docker-compose.yml`, then run `docker compose pull && docker compose up -d`. Back up your data before upgrading.

## Troubleshooting

```bash
docker compose logs -f comfyui
docker compose ps
```

If GPU acceleration is unavailable, verify the NVIDIA driver and NVIDIA Container Toolkit on the host.

ComfyUI does not include authentication by default. Do not expose port `8188` directly to the public internet.

[ZimaOS guide](ZIMAOS.md) · [License notices](LICENSE-NOTICE.md)
