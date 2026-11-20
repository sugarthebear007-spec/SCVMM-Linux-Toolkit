#!/usr/bin/env bash
set -uo pipefail
R="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$R/variables.sh"; source "$R/lib.sh"
for f in "$R"/steps/step*.sh; do source "$f"; done
init_paths
audit_all(){ local n; for n in $(seq 1 13); do run_step "$n"; done; }
certify(){ audit_all; step14_certify; }
case "${1:---dashboard}" in
 --help|-h) echo './manager.sh [--dashboard|--audit|--step N|--certify]' ;;
 --audit) audit_all; show_dashboard ;;
 --step) [[ "${2:-}" =~ ^([1-9]|1[0-3])$ ]] || exit 2; run_step "$2"; show_dashboard ;;
 --certify) certify; show_dashboard ;;
 --dashboard)
 while :; do clear 2>/dev/null || true; show_dashboard; echo '[A]udit all [C]ertify [R]efresh [Q]uit'; read -r -t "$REFRESH_SECONDS" -n 1 c || c=r
 case "${c,,}" in a) audit_all; read -r -p 'Enter...' ;; c) certify; read -r -p 'Enter...' ;; q) break ;; esac
 done ;;
 *) echo 'Unknown option'; exit 2 ;;
esac
