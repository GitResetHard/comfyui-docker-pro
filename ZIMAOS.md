# ComfyUI Docker Pro — ZimaOS

## Install

1. In ZimaOS, select **Install a customized app** and import [docker-compose.zimaos.yml](docker-compose.zimaos.yml).
2. Switch from **YAML** to **Form** to review or change the app settings.
3. Under **Basic**, check the image name and tag.
4. Under **Networks**, keep port forwarding **8188 → 8188 (TCP)**.
5. Under **Volumes**, keep the bind mount **/DATA/AppData/comfyui → /data**. This stores your models, custom nodes, settings and outputs.
6. Under **Resources**, enable **NVIDIA GPU Support** and select the GPU to use. The supplied YAML selects GPU **0**.
7. Click **Save** to install the app. Open ComfyUI using its ZimaOS app tile.

## Configure the app

Open the app's **Edit** screen and select **Form**.

| Section | Setting |
| --- | --- |
| Basic | Change the image tag when upgrading |
| Networks | Configure the host and container ports |
| Volumes | Set the persistent storage path |
| Environment | Adjust timezone or NVIDIA environment variables |
| Resources | Select NVIDIA GPU, CPU and memory limits |
| Runtime | Set startup command arguments if needed |

Click **Save** to apply changes. Back up `/DATA/AppData/comfyui` before upgrading. Keep the existing volume mount when editing or recreating the app.

## Optional legacy Manager UI

ComfyUI Manager is enabled by default. To enable its legacy interface:

1. Open **Edit → Form → Advanced → Runtime**.
2. In **Command**, enter the following arguments, **one item per line**:

```text
python
main.py
--listen
0.0.0.0
--port
8188
--base-directory
/data
--enable-manager
--enable-manager-legacy-ui
```

3. Leave **Entrypoint** empty and click **Save**.

The Command field replaces the image's default command, so all arguments above are required. To return to the standard Manager, clear the **Command** field and save.

## Storage and updates

The app stores data at `/DATA/AppData/comfyui`. In **Edit → Form → Basic**, change the image **Tag** to an available published version when upgrading. Keep the same bind mount and GPU selection.
