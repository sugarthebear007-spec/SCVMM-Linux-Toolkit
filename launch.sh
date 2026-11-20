#!/usr/bin/env bash
set -Eeuo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Starting SCVMM Linux Template Manager..."

exec sudo bash "$DIR/scvmm-linux-template-manager.sh"
