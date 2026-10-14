# Changelog

## [1.0.3](https://github.com/GitResetHard/comfyui-docker-pro/compare/v1.0.2...v1.0.3) (2026-10-14)


### Bug Fixes

* restore default runtime capabilities for gosu user switch ([56705e2](https://github.com/GitResetHard/comfyui-docker-pro/commit/56705e2e1120a8f22353202511dd968ecd3cc18b))
* restore default runtime capabilities for gosu user switch ([249a8b4](https://github.com/GitResetHard/comfyui-docker-pro/commit/249a8b4dda63d1717f73eb063e911d1a5366d19c))
* separate ZimaOS GUI configuration from Compose environment setup ([9598f56](https://github.com/GitResetHard/comfyui-docker-pro/commit/9598f56a621091b12b3b67cb5842487102e0a57a))
* separate ZimaOS GUI configuration from Compose environment setup ([7e94b1f](https://github.com/GitResetHard/comfyui-docker-pro/commit/7e94b1f429d24a9829588df39f95b7df958f3742))
* separate ZimaOS GUI configuration from Compose environment setup ([09bdd9e](https://github.com/GitResetHard/comfyui-docker-pro/commit/09bdd9e4bfce60af7fae966c32a7e527900fba9b))
* use published GHCR image in standard Compose example ([4abec44](https://github.com/GitResetHard/comfyui-docker-pro/commit/4abec442cf6967589566acccbc3887a8b8eefd6c))
* use published GHCR image in standard Compose example ([efe1c82](https://github.com/GitResetHard/comfyui-docker-pro/commit/efe1c8260019a5671d870431046d883326b6a88e))
* use published GHCR image in standard Compose example ([1d9f9f4](https://github.com/GitResetHard/comfyui-docker-pro/commit/1d9f9f4755f5aa73f7c1c257f00f02ef2eaa46d2))
* **zimaos:** reference published v1.0.2 image ([e09a7f4](https://github.com/GitResetHard/comfyui-docker-pro/commit/e09a7f42ffa2197c09448e5339cf2d6d00287f8b))

## [1.0.2](https://github.com/GitResetHard/comfyui-docker-pro/compare/v1.0.1...v1.0.2) (2026-10-14)


### Bug Fixes

* allow gosu to drop root privileges at startup ([b3bf70b](https://github.com/GitResetHard/comfyui-docker-pro/commit/b3bf70b401b0de120c30b806e10470dcf2fa49d8))
* allow gosu to drop root privileges at startup ([3f42956](https://github.com/GitResetHard/comfyui-docker-pro/commit/3f42956641668a4775e2ceb91839039a3e09faa8))

## [1.0.1](https://github.com/GitResetHard/comfyui-docker-pro/compare/v1.0.0...v1.0.1) (2026-10-14)


### Bug Fixes

* **zimaos:** remove conflicting memory reservation from GPU compose ([3fb4e90](https://github.com/GitResetHard/comfyui-docker-pro/commit/3fb4e90833e46632dc4dc1d6691a42fb493e33c8))
* **zimaos:** replace unsupported gpus field with NVIDIA device reservation ([0682fc6](https://github.com/GitResetHard/comfyui-docker-pro/commit/0682fc6522612e2f3629aaeb60bc0db2a45e93db))

## 1.0.0 (2026-10-14)


### Features

* add .dockerignore ([1d1f006](https://github.com/GitResetHard/comfyui-docker-pro/commit/1d1f0061274d824c1761b06775361078032406cb))
* add .env.example ([80c52ee](https://github.com/GitResetHard/comfyui-docker-pro/commit/80c52ee29ee25f1d87075fe7253f8686bdf293f0))
* add .github/workflows/publish.yml ([263bd19](https://github.com/GitResetHard/comfyui-docker-pro/commit/263bd19a78282f02d4f575023a5ce4ab5da4fc4b))
* add .github/workflows/validate.yml ([ccda2d9](https://github.com/GitResetHard/comfyui-docker-pro/commit/ccda2d91666418f976341b11f2f2a77793463fb3))
* add compose.yaml ([3b02abb](https://github.com/GitResetHard/comfyui-docker-pro/commit/3b02abbf46e2cdd7b337e68f8ecb483b5923bbb7))
* add Dockerfile ([e6d9109](https://github.com/GitResetHard/comfyui-docker-pro/commit/e6d910982c8fc3b9de8a0d6cd0484edb19bda166))
* add independent docker-compose.zimaos.yml ([8943737](https://github.com/GitResetHard/comfyui-docker-pro/commit/894373709e33ae83945f7b4047c93bf1cdd61555))
* add LICENSE-NOTICE.md ([4209451](https://github.com/GitResetHard/comfyui-docker-pro/commit/420945156f90f7e7c9ab720d8c396ae58a047aa0))
* add README.md ([f1a80b5](https://github.com/GitResetHard/comfyui-docker-pro/commit/f1a80b5b8a2dd20da7fd47631f95e502e0d86229))
* add scripts/entrypoint.sh ([ad92460](https://github.com/GitResetHard/comfyui-docker-pro/commit/ad92460458556b12f289365c84cda0375b61c409))
* add ZimaOS NVIDIA docker-compose.yml ([b13bf87](https://github.com/GitResetHard/comfyui-docker-pro/commit/b13bf8754a3a4b51932ce435ff0a7067952bbde1))


### Bug Fixes

* align startup and CI with ZimaOS Compose deployment ([acad059](https://github.com/GitResetHard/comfyui-docker-pro/commit/acad0593171779b7d89236a1e9db8a3aff12cd94))
* align startup and CI with ZimaOS Compose deployment ([3f5235f](https://github.com/GitResetHard/comfyui-docker-pro/commit/3f5235f0a962bc1f3b4cd9899b5f1bedee152dfb))
* initialize mounts in image and drop to comfy user ([0c31814](https://github.com/GitResetHard/comfyui-docker-pro/commit/0c31814577f204f6489dc08fa782a68419b655ab))
* initialize persistent data safely before starting ComfyUI ([0d306a7](https://github.com/GitResetHard/comfyui-docker-pro/commit/0d306a7353f364975eec5e639faeab725bcb0034))
* install gosu for rootless ComfyUI after mount initialization ([f27c638](https://github.com/GitResetHard/comfyui-docker-pro/commit/f27c638cf834a4221c32d0948cce08b5bd01a17f))
* lowercase GHCR repository name for Docker publish ([79ebdd7](https://github.com/GitResetHard/comfyui-docker-pro/commit/79ebdd719e9cff47edb755164d176432750fa189))
* make .env.example platform-independent ([fe3171b](https://github.com/GitResetHard/comfyui-docker-pro/commit/fe3171b2163f1786844ad27c263d32753372f4ff))
* make docker-compose.yml platform-independent ([8708618](https://github.com/GitResetHard/comfyui-docker-pro/commit/87086182a804075f5c8aeb1483d98a5c9f852a97))
* single-service Compose and native ZimaOS app metadata ([ea7f42f](https://github.com/GitResetHard/comfyui-docker-pro/commit/ea7f42f0efdbc340b191df5753c0dfc74918a0ba))
* single-service Compose and native ZimaOS app metadata ([6288b21](https://github.com/GitResetHard/comfyui-docker-pro/commit/6288b210c6292d027498bf256ebcee9ce18aa640))
* use supported GitHub CLI release flags ([f696bc1](https://github.com/GitResetHard/comfyui-docker-pro/commit/f696bc1a26fcf8880b633e0458ccc28ec60f33ed))
