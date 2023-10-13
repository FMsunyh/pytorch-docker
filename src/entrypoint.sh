#!/bin/bash

set -Eeuo pipefail

# TODO: move all mkdir -p ?
mkdir -p /userdata/config/auto/scripts/
# mount scripts individually
find "${ROOT}/scripts/" -maxdepth 1 -type l -delete
cp -vrfTs /userdata/config/auto/scripts/ "${ROOT}/scripts/"

# Set up config file
python /docker/config.py /userdata/config/auto/config.json

if [ ! -f /userdata/config/auto/ui-config.json ]; then
  echo '{}' >/userdata/config/auto/ui-config.json
fi

if [ ! -f /userdata/config/auto/styles.csv ]; then
  touch /userdata/config/auto/styles.csv
fi

# copy models from original models folder
mkdir -p /userdata/models/VAE-approx/ /userdata/models/karlo/

rsync -a --info=NAME ${ROOT}/models/VAE-approx/ /userdata/models/VAE-approx/
rsync -a --info=NAME ${ROOT}/models/karlo/ /userdata/models/karlo/

declare -A MOUNTS

MOUNTS["/root/.cache"]="/userdata/.cache"
MOUNTS["${ROOT}/models"]="/userdata/models"

MOUNTS["${ROOT}/embeddings"]="/userdata/embeddings"
MOUNTS["${ROOT}/config.json"]="/userdata/config/auto/config.json"
MOUNTS["${ROOT}/ui-config.json"]="/userdata/config/auto/ui-config.json"
MOUNTS["${ROOT}/styles.csv"]="/userdata/config/auto/styles.csv"
MOUNTS["${ROOT}/extensions"]="/userdata/config/auto/extensions"
MOUNTS["${ROOT}/config_states"]="/userdata/config/auto/config_states"

# extra hacks
MOUNTS["${ROOT}/repositories/CodeFormer/weights/facelib"]="/userdata/.cache"

for to_path in "${!MOUNTS[@]}"; do
  set -Eeuo pipefail
  from_path="${MOUNTS[${to_path}]}"
  rm -rf "${to_path}"
  echo "${to_path}"
  if [ ! -f "$from_path" ]; then
    mkdir -vp "$from_path"
  fi
  mkdir -vp "$(dirname "${to_path}")"
  ln -sT "${from_path}" "${to_path}"
  echo Mounted $(basename "${from_path}")
done

echo "Installing extension dependencies (if any)"

# because we build our container as root:
chown -R root ~/.cache/
chmod 766 ~/.cache/

shopt -s nullglob
# For install.py, please refer to https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/Developing-extensions#installpy
list=(./extensions/*/install.py)
for installscript in "${list[@]}"; do
  PYTHONPATH=${ROOT} python "$installscript"
done

if [ -f "/userdata/config/auto/startup.sh" ]; then
  pushd ${ROOT}
  echo "Running startup script"
  . /userdata/config/auto/startup.sh
  popd
fi

exec "$@"
