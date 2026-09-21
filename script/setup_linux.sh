#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOST_HOME="${HOME:-$(getent passwd "$(id -un)" | cut -d: -f6)}"

mkdir -p \
  "${ROOT_DIR}/data/.config/nvim" \
  "${ROOT_DIR}/data/.local/share/nvim" \
  "${ROOT_DIR}/data/.local/state/nvim" \
  "${ROOT_DIR}/data/.cache/nvim" \
  "${ROOT_DIR}/host"

ensure_link() {
  local src="$1"
  local dst="$2"

  mkdir -p "$(dirname "${dst}")"

  if [ -L "${dst}" ] || [ -e "${dst}" ]; then
    if [ -L "${dst}" ] && [ "$(readlink "${dst}")" = "${src}" ]; then
      return
    fi

    read -r -p "${dst} already exists. Overwrite it? [y/N] " answer || answer=""
    if [[ "${answer}" != [Yy] ]]; then
      echo "[skip] ${dst}: leaving it unchanged"
      return
    fi

    rm -rf -- "${dst}"
  fi

  ln -s "${src}" "${dst}"
}

# Same role as docker-compose volume mounts:
# - project config is mounted read-only into the container
# - plugin cache/state are kept under the project data directory
ensure_link "${ROOT_DIR}/data/.config/nvim" "${HOST_HOME}/.config/nvim"
ensure_link "${ROOT_DIR}/data/.local/share/nvim" "${HOST_HOME}/.local/share/nvim"
ensure_link "${ROOT_DIR}/data/.local/state/nvim" "${HOST_HOME}/.local/state/nvim"
ensure_link "${ROOT_DIR}/data/.cache/nvim" "${HOST_HOME}/.cache/nvim"
ensure_link "${ROOT_DIR}/data/.gitconfig" "${HOST_HOME}/.gitconfig"
ensure_link "${ROOT_DIR}/data/.bashrc" "${HOST_HOME}/.bashrc"
ensure_link "${ROOT_DIR}/data/.tmux.conf" "${HOST_HOME}/.tmux.conf"

cat <<EOF
[ok] Host setup completed.

Project root: ${ROOT_DIR}
Host home: ${HOST_HOME}

Mounted-equivalent paths:
  ${HOST_HOME}/host -> ${ROOT_DIR}/host
  ${HOST_HOME}/.config/nvim -> ${ROOT_DIR}/data/.config/nvim
  ${HOST_HOME}/.local/share/nvim -> ${ROOT_DIR}/data/.local/share/nvim
  ${HOST_HOME}/.local/state/nvim -> ${ROOT_DIR}/data/.local/state/nvim
  ${HOST_HOME}/.cache/nvim -> ${ROOT_DIR}/data/.cache/nvim
  ${HOST_HOME}/.gitconfig -> ${ROOT_DIR}/data/.gitconfig
  ${HOST_HOME}/.bashrc -> ${ROOT_DIR}/data/.bashrc
  ${HOST_HOME}/.tmux.conf -> ${ROOT_DIR}/data/.tmux.conf
EOF
