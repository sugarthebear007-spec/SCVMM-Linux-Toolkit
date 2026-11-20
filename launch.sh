#!/usr/bin/env bash
set -Eeuo pipefail
DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
echo "Starting SCVMM Linux Template Preparation Manager..."
exec sudo bash "$DIR/manager.sh" "$@"
