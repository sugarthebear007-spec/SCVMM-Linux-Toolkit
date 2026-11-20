#!/usr/bin/env bash
set -uo pipefail
SCVMM_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCVMM_ROOT/variables.sh"
source "$SCVMM_ROOT/lib.sh"
scvmm_init_paths || exit 1
scvmm_load_modules || exit 1

usage() {
    cat <<USAGE
$TOOL_NAME v$TOOL_VERSION

Usage: bash manager.sh [command]
  --dashboard             Open the interactive color dashboard (default)
  --existing-vm           Read-only audit of a partially prepared VM
  --new-install [--yes]   Audit each step, run its fix handler when needed,
                          verify it, then run Step 14 certification
  --audit                 Run all 13 read-only audits
  --step N [audit|fix|verify|workflow]
  --certify               Re-audit all 13 steps, then run Step 14 certification
  --reset [N|all]         Clear saved result(s); resetting a prep step also
                          clears Step 14 certification
  --help                  Show this help

Options:
  --yes                   Confirm the explicitly selected --new-install workflow

Environment:
  SCVMM_STATE_ROOT, SCVMM_LOG_ROOT, SCVMM_REFRESH_SECONDS, SCVMM_MODULE_ROOT
  NO_COLOR=1              Disable ANSI dashboard colors

Audit is read-only with respect to the guest. Repair handlers are separate.
The dashboard refresh is display-only and never launches checks or repairs.
USAGE
}

run_new_install() {
    confirm_action 'Run the full new-install workflow? Step fix handlers may modify this VM.' || return 1
    local id
    for id in $(seq 1 "$STEP_COUNT"); do run_step_workflow "$id" || true; done
    certify_all
}

interactive_dashboard() {
    local choice id action
    while :; do
        if [[ -t 1 ]]; then clear 2>/dev/null || true; fi
        show_dashboard
        printf '[A]udit all  [E]xisting VM audit + certify  [N]ew install workflow  [S]tep action\n'
        printf '[C]ertify  [R]eset  [Q]uit  (auto-refresh %ss)\n> ' "$REFRESH_SECONDS"
        if ! read -r -t "$REFRESH_SECONDS" choice; then continue; fi
        case "${choice,,}" in
            a) audit_all; read -r -p 'Audit complete. Press Enter...' _ ;;
            e) certify_all || true; read -r -p 'Existing-VM assessment complete. Press Enter...' _ ;;
            n) run_new_install; read -r -p 'Workflow complete. Press Enter...' _ ;;
            s)
                read -r -p 'Preparation step (1-13): ' id
                [[ "$id" =~ ^([1-9]|1[0-3])$ ]] || continue
                printf 'Actions: audit / fix / verify / workflow\n'
                read -r -p 'Action: ' action
                case "$action" in
                    audit|verify) run_step "$id" "$action" ;;
                    fix) confirm_action "Run Step $id repair handler?" && { run_step "$id" fix; run_step "$id" verify; } ;;
                    workflow) confirm_action "Run Step $id audit/fix/verify workflow?" && run_step_workflow "$id" ;;
                    *) printf 'Unknown action.\n' ;;
                esac
                read -r -p 'Press Enter...' _ ;;
            c) certify_all || true; read -r -p 'Certification complete. Press Enter...' _ ;;
            r)
                read -r -p 'Reset step number (1-14) or all: ' id
                if [[ "$id" == all || "$id" =~ ^([1-9]|1[0-4])$ ]]; then confirm_action "Reset saved state for $id?" && reset_state "$id"; fi
                read -r -p 'Press Enter...' _ ;;
            q) break ;;
            '') ;;
            *) printf 'Unknown selection.\n'; sleep 1 ;;
        esac
    done
}

command="${1:---dashboard}"
case "$command" in
    --help|-h) usage ;;
    --dashboard) interactive_dashboard ;;
    --existing-vm) certify_all || true; show_dashboard ;;
    --audit) audit_all; show_dashboard ;;
    --new-install)
        shift
        [[ "${1:-}" == --yes ]] && SCVMM_ASSUME_YES=1
        run_new_install || exit 1
        show_dashboard ;;
    --step)
        id="${2:-}"; action="${3:-audit}"
        [[ "$id" =~ ^([1-9]|1[0-3])$ ]] || { usage >&2; exit 2; }
        case "$action" in
            audit|verify) run_step "$id" "$action" ;;
            fix) confirm_action "Run Step $id repair handler?" || exit 1; run_step "$id" fix; run_step "$id" verify ;;
            workflow) confirm_action "Run Step $id audit/fix/verify workflow?" || exit 1; run_step_workflow "$id" ;;
            *) usage >&2; exit 2;;
        esac
        show_dashboard ;;
    --certify) certify_all || true; show_dashboard ;;
    --reset)
        target="${2:-all}"
        confirm_action "Reset saved state for $target?" || exit 1
        reset_state "$target"; show_dashboard ;;
    --yes) printf '%s\n' '--yes must follow --new-install.' >&2; exit 2 ;;
    *) usage >&2; exit 2 ;;
esac
