#!/usr/bin/env bash
set -Eeuo pipefail

# UID/GID 1000 match the image's non-root application user.
# Initialize top-level mount directories once, without recursively touching models.
for dir in /data /data/models /data/custom_nodes /data/input /data/output /data/temp /data/user /data/cache; do
  mkdir -p "$dir"
  if [[ "$(stat -c %u "$dir")" != "1000" || "$(stat -c %g "$dir")" != "1000" ]]; then
    chown 1000:1000 "$dir"
  fi
done
if [[ "$(id -u)" != "0" ]]; then
  echo "ERROR: entrypoint requires root to initialize mounts; it immediately drops to UID 1000." >&2
  exit 1
fi
for dir in models/checkpoints models/clip models/clip_vision models/controlnet models/diffusers models/diffusion_models models/embeddings models/loras models/text_encoders models/unet models/upscale_models models/vae models/vae_approx models/photomaker models/style_models; do
  mkdir -p "/data/$dir"
  chown 1000:1000 "/data/$dir"
done
if [[ -n "${COMFY_EXTRA_ARGS:-}" ]]; then
  read -r -a extra_args <<< "$COMFY_EXTRA_ARGS"
  set -- "$@" "${extra_args[@]}"
fi
exec gosu comfy "$@"
