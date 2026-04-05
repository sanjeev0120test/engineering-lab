#!/usr/bin/env bash
# Run Ansible CLI tools using the repo virtualenv at .venv (macOS / Linux native).
# One-time setup (from repo root): see README "Ansible on macOS".
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
VENV="${REPO_ROOT}/.venv"
ACTIVATE="${VENV}/bin/activate"

if [[ ! -f "${ACTIVATE}" ]]; then
  cat >&2 <<EOF
Missing virtualenv: ${VENV}

From the repository root, run once:

  cd ${REPO_ROOT}
  python3 -m venv .venv
  source .venv/bin/activate
  pip install -r requirements-ansible.txt
  ansible-galaxy collection install -r ansible/collections.yml

Then re-run this script.
EOF
  exit 1
fi

# shellcheck source=/dev/null
source "${ACTIVATE}"
cd "${REPO_ROOT}"

if [[ $# -eq 0 ]]; then
  # Interactive shell with venv already activated (PATH inherited by child process)
  exec "${SHELL:-/bin/zsh}"
fi

exec "$@"
