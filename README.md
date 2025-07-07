# nur-packages-template

An opinionated template for [NUR](https://github.com/nix-community/NUR) repositories

## Setup

1. Click on [Use this template](https://github.com/nix-community/nur-packages-template/generate) <!-- markdownlint-disable-line MD013 -->
   to start a repo based on this template. (Do _not_ fork it.)
2. Add your packages to the [pkgs](./pkgs) directory and to
   [default.nix](./default.nix)
   * Remember to mark the broken packages as `broken = true;` in the `meta`
     attribute, or CI (and consequently caching) will fail!
   * Library functions, modules and overlays go in the respective directories
3. Configure CI: Change your NUR repo name and optionally add a cachix name in
   [.github/workflows/build.yml](./.github/workflows/build.yml) and change the
   cron timer to a random value as described in the file.
4. Change your cachix name on the README template section and delete the rest
5. [Add yourself to NUR](https://github.com/nix-community/NUR#how-to-add-your-own-repository) <!-- markdownlint-disable-line MD013 -->

<!-- markdownlint-disable-next-line MD025 -->
# nur-packages

My personal [NUR](https://github.com/nix-community/NUR) repository

![Build and populate cache](https://github.com/<YOUR-GITHUB-USER>/nur-packages/workflows/Build%20and%20populate%20cache/badge.svg)

[![Cachix Cache](https://img.shields.io/badge/cachix-<YOUR_CACHIX_CACHE_NAME>-blue.svg)](https://<YOUR_CACHIX_CACHE_NAME>.cachix.org)
