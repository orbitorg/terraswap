#!/usr/bin/env bash

set -e
set -o pipefail

projectPath=$(cd "$(dirname "$0")" && pwd)
folderName=$(basename "$projectPath")

mkdir -p "${projectPath}-cache"
mkdir -p "${projectPath}-cache/target"
mkdir -p "${projectPath}-cache/registry"

docker run --rm -v "${projectPath}":/code \
  --mount type=bind,source="${projectPath}-cache/target",target=/code/target \
  --mount type=bind,source="${projectPath}-cache/registry",target=/usr/local/cargo/registry \
  cosmwasm/workspace-optimizer:0.15.1