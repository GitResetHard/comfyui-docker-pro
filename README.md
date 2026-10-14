# ComfyUI Docker Pro

Unofficial NVIDIA container for [ComfyUI](https://github.com/Comfy-Org/ComfyUI), including the built-in Manager. Supports standard Docker Compose on Linux with NVIDIA Container Toolkit.

## Installation

Clone the repository and copy the configuration:

```bash
git clone https://github.com/GitResetHard/comfyui-docker-pro.git
cd comfyui-docker-pro
cp .env.example .env
docker compose up -d --build
```

The web interface listens at `http://127.0.0.1:8188` by default. Set `COMFY_BIND` for access from other trusted hosts. Model weights are not included.

## Deployment options

- [docker-compose.yml](docker-compose.yml) — standard Docker Compose, local image build and persistent named volume.
- [docker-compose.zimaos.yml](docker-compose.zimaos.yml) — ZimaOS custom-app manifest, image-based deployment, NVIDIA GPU and persistent data under `/DATA/AppData/comfyui`.

## Images and releases

Prebuilt NVIDIA images are available from [GitHub Releases](https://github.com/GitResetHard/comfyui-docker-pro/releases) and [GitHub Packages](https://github.com/users/GitResetHard/packages).

The release workflow builds and tests the image, publishes a versioned GHCR package, and creates a matching GitHub release. Releases run weekly and can also be started manually by a maintainer. Builds from source are supported through the Dockerfile.

## Persistent data

ComfyUI keeps models, custom nodes, user preferences, inputs, outputs and caches under `/data`. The image entrypoint creates directories and adjusts only required directory ownership on startup before dropping privileges to UID 1000; it does not recursively take ownership of user model files. Existing files with incompatible ACLs may require separate correction.

Community custom nodes are installed at your discretion through Manager. Because nodes can demand incompatible dependencies, the image does not bundle every extension. Install pinned extra Python dependencies in a derived image if they must persist across upgrades.

## Operations

```bash
docker compose ps
docker compose logs -f comfyui
docker compose exec comfyui python -m pip check
docker compose exec comfyui python -c 'import torch; print(torch.cuda.is_available())'
```

The final check should return `True` with working NVIDIA passthrough. Back up your persistent data before upgrading. Use `docker compose up -d --build` to rebuild the local image. For a prebuilt versioned image, configure `COMFY_IMAGE` and pull that specific tag.

## Environment

See [.env.example](.env.example) for image/build ref, host binding, port, timezone, RAM and shared-memory limits, additional flags and log rotation. The ZimaOS manifest has independent inline settings.

## Security and compatibility

Keep ComfyUI behind a trusted network or authenticated reverse proxy; it does not provide default authentication. Custom nodes execute third-party code. Containers request an NVIDIA GPU, use rotating logs and a health check, and drop most Linux capabilities. ComfyUI starts without root privileges following storage initialization.

GitHub CI validates Compose syntax and builds the image. CUDA access, successful inference, host permission behavior and reboot recovery must still be checked on the target hardware.

See [LICENSE-NOTICE.md](LICENSE-NOTICE.md).
