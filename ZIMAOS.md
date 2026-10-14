# ZimaOS — ComfyUI Docker Pro

This guide is for **ZimaOS users working entirely in the web interface**. No terminal commands or `.env` files are required.

## Install using the ZimaOS GUI

1. Open your ZimaOS dashboard.
2. Choose **Install a customized app**, then **Import** and select the Docker Compose import option.
3. Copy the contents of [docker-compose.zimaos.yml](docker-compose.zimaos.yml) into the importer.
4. Review the GPU, port `8188`, and persistent bind mount `/DATA/AppData/comfyui`, then install the app.

The manifest uses a prebuilt NVIDIA image and preserves models and other ComfyUI data in `/DATA/AppData/comfyui`.

## Optional legacy ComfyUI Manager interface

The built-in Manager is already enabled. To additionally enable the **legacy Manager web UI**:

1. In ZimaOS, open the custom app's settings and its Compose/YAML editor.
2. Find the `command:` section in the `comfyui` service.
3. Uncomment the last line by removing the `#` before `- --enable-manager-legacy-ui`.
4. Save/apply the configuration so ZimaOS recreates the container.

The command ends like this when enabled:

```yaml
      - --base-directory
      - /data
      - --enable-manager
      - --enable-manager-legacy-ui
```

To disable it, comment out the last line again. **No environment variables, `.env` file, or terminal are involved.**

If your ZimaOS version does not expose a Compose editor for the installed app, use its custom-app import/edit workflow to apply the updated YAML. Preserve the same `/DATA/AppData/comfyui` mount so your data stays in place.

## Standard Docker Compose

For non-ZimaOS installation, see [README.md](README.md). That workflow uses a separate `.env` file and is not part of the ZimaOS instructions.
