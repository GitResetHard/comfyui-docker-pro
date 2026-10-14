#!/usr/bin/env bash
set -Eeuo pipefail

# The one-shot Compose init-data service creates the top-level bind mount and
# its writable directories. This script also works without Compose.
for dir in models/checkpoints models/clip models/clip_vision models/controlnet   models/diffusers models/diffusion_models models/embeddings models/loras   models/text_encoders models/unet models/upscale_models models/vae   models/vae_approx models/photomaker models/style_models   custom_nodes input output temp user cache; do
  if ! mkdir -p "/data/$dir"; then
    echo "ERROR: cannot create /data/$dir as UID $(id -u); check host ACLs/ownership." >&2
    exit 1
  fi
done

for dir in /data/custom_nodes /data/output /data/user /data/temp; do
  if [[ ! -w "$dir" ]]; then
    echo "ERROR: $dir is not writable by UID $(id -u). Fix host permissions." >&2
    exit 1
  fi
done

# ComfyUI arguments are whitespace-delimited, intentionally not shell-evaluated.
if [[ -n "${COMFY_EXTRA_ARGS:-}" ]]; then
  read -r -a extra_args <<< "$COMFY_EXTRA_ARGS"
  set -- "$@" "${extra_args[@]}"
fi
exec "$@"
