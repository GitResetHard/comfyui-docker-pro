# ComfyUI Docker Pro — ZimaOS

Install and configure ComfyUI entirely through the **ZimaOS web interface**.

## Install

1. Open the ZimaOS dashboard and choose **Install a customized app**.
2. Open the Compose import/editor option.
3. Paste the contents of [docker-compose.zimaos.yml](docker-compose.zimaos.yml).
4. Review the NVIDIA GPU configuration, port `8188`, and storage path `/DATA/AppData/comfyui`.
5. Install the app, then open ComfyUI from its ZimaOS app tile.

The prebuilt NVIDIA image is specified directly in the ZimaOS Compose configuration. Models, custom nodes, inputs, outputs, and user data are stored at `/DATA/AppData/comfyui`.

## Optional legacy Manager UI

The built-in ComfyUI Manager is enabled by default. The legacy Manager interface is optional.

1. Open the ComfyUI custom app's **Compose/YAML editor** in ZimaOS.
2. Find the `command:` section.
3. Change the final line from `# - --enable-manager-legacy-ui` to `- --enable-manager-legacy-ui`.
4. Save and apply the changes in the ZimaOS interface.

The final command arguments should look like:

```yaml
      - --base-directory
      - /data
      - --enable-manager
      - --enable-manager-legacy-ui
```

To return to the default Manager UI, comment out the last line and apply the configuration again.

If the installed app does not offer a Compose editor, use the ZimaOS custom-app import/edit interface to apply the revised configuration. Keep the existing `/DATA/AppData/comfyui` storage mapping.

## Storage and updates

The app's persistent storage is mapped to `/DATA/AppData/comfyui`. Keep that mapping when updating or recreating the app. The image version is selected by the `image:` line in the ZimaOS Compose editor. Back up your persistent data before upgrading.
