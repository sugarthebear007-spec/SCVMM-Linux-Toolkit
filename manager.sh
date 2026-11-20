#!/usr/bin/env bash
set -uo pipefail
R="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$R/variables.sh"; source "$R/lib.sh"
for f in "$R"/steps/step*.sh; do source "$f"; done
init_paths
audit_all(){ local n; for n in $(seq 1 13); do run_step "$n" audit >/dev/null; done; }
certify(){ audit_all; step14_certify; }
reset_state(){
 local target="${1:-all}" tmp
 tmp="$(mktemp "$STATE_ROOT/.reset.XXXX")" || return 1
 if [[ "$target" == all ]]; then : > "$tmp"; else
  [[ "$target" =~ ^([1-9]|1[0-4])$ ]] || { rm -f "$tmp"; echo 'Reset target must be 1-14 or all'; return 2; }
  awk -F '\t' -v i="$target" '$1!=i' "$STATE_FILE" > "$tmp"
  [[ "$target" == 14 ]] || awk -F '\t' '$1!=14' "$tmp" > "$tmp.next" && mv "$tmp.next" "$tmp"
 fi
 mv "$tmp" "$STATE_FILE"; echo "State reset: $target"
}
case "${1:---dashboard}" in
 --help|-h) echo './manager.sh [--dashboard|--audit|--step N [audit|fix|verify]|--certify|--reset N|all]' ;;
 --audit) audit_all; show_dashboard ;;
 --step)
  [[ "${2:-}" =~ ^([1-9]|1[0-3])$ ]] || exit 2
  action="${3:-audit}"; [[ "$action" =~ ^(audit|fix|verify)$ ]] || exit 2
  run_step "$2" "$action"; show_dashboard ;;
 --certify) certify; show_dashboard ;;
 --reset) reset_state "${2:-all}"; show_dashboard ;;
 --dashboard)
 while :; do
  audit_all
  clear 2>/dev/null || true; show_dashboard
  echo '[A]udit all [S]tep action [C]ertify [X]Reset [Q]uit'
  read -r -t "$REFRESH_SECONDS" -n 1 c || c=r
  case "${c,,}" in
   a) audit_all; read -r -p 'Enter...' ;;
   s) read -r -p 'Step number (1-13): ' n; if [[ "$n" =~ ^([1-9]|1[0-3])$ ]]; then read -r -p 'Action audit/fix/verify: ' action; [[ "$action" =~ ^(audit|fix|verify)$ ]] && run_step "$n" "$action"; fi; read -r -p 'Enter...' ;;
   c) certify; read -r -p 'Enter...' ;;
   x) reset_state all; read -r -p 'Enter...' ;;
   q) break ;;
  esac
 done ;;
 *) echo 'Unknown option'; exit 2 ;;
esac
