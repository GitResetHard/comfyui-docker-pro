#!/usr/bin/env bash
set -Eeuo pipefail
for dir in models/checkpoints models/clip models/clip_vision models/controlnet models/diffusers models/diffusion_models models/embeddings models/loras models/text_encoders models/unet models/upscale_models models/vae models/vae_approx models/photomaker models/style_models custom_nodes input output temp user cache; do
  mkdir -p "/data/$dir"
done
if [[ ! -w /data/output ]]; then
  echo 'ERROR: /data/output is not writable by container UID 1000.' >&2
  exit 1
fi
exec "$@"
