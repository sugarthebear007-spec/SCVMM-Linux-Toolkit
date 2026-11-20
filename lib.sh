#!/usr/bin/env bash
# Core engine. Step modules provide stepNN_{audit,fix,verify} functions only.

scvmm_init_paths() {
    if [[ -z "$STATE_ROOT" ]]; then
        if (( EUID == 0 )); then STATE_ROOT=/var/lib/scvmm-template; else STATE_ROOT="${XDG_STATE_HOME:-$HOME/.local/state}/scvmm-template"; fi
    fi
    if [[ -z "$LOG_ROOT" ]]; then
        if (( EUID == 0 )); then LOG_ROOT=/var/log/scvmm-template; else LOG_ROOT="${XDG_STATE_HOME:-$HOME/.local/state}/scvmm-template/log"; fi
    fi
    MODULE_ROOT="${MODULE_ROOT:-$SCVMM_ROOT/steps}"
    STATE_FILE="$STATE_ROOT/steps.tsv"
    ACTIVITY_LOG="$LOG_ROOT/activity.log"
    mkdir -p -- "$STATE_ROOT" "$LOG_ROOT" || { printf 'ERROR: Cannot create state/log directories.\n' >&2; return 1; }
    touch -- "$STATE_FILE" "$ACTIVITY_LOG" || { printf 'ERROR: Cannot initialize state/log files.\n' >&2; return 1; }
    chmod 700 "$STATE_ROOT" "$LOG_ROOT" 2>/dev/null || true
}

scvmm_log() {
    local event="$1" detail="${2:-}" now
    now="$(date -Is 2>/dev/null || date)"
    detail="${detail//$'\t'/ }"; detail="${detail//$'\n'/ }"
    printf '%s\t%s\t%s\n' "$now" "$event" "$detail" >> "$ACTIVITY_LOG"
}

set_step_result() {
    STEP_STATUS="${1:-WARN}"
    STEP_MESSAGE="${2:-No detail supplied}"
    case "$STEP_STATUS" in PASS|WARN|FAIL) ;; *) STEP_STATUS=FAIL; STEP_MESSAGE='Invalid step status returned by module';; esac
}

step_name() {
    case "$1" in
        1) printf '%s' 'Base OS / kernel / Hyper-V integration';;
        2) printf '%s' 'SCVMM guest agent';;
        3) printf '%s' 'cloud-init / specialization';;
        4) printf '%s' 'SSH host identity';;
        5) printf '%s' 'Machine ID / D-Bus identity';;
        6) printf '%s' 'DHCP lease state';;
        7) printf '%s' 'NIC / network identity';;
        8) printf '%s' 'Subscription identity';;
        9) printf '%s' 'fstab UUID / LABEL references';;
        10) printf '%s' 'Logs and command history';;
        11) printf '%s' 'SCVMM agent logs';;
        12) printf '%s' 'Disk reclamation';;
        13) printf '%s' 'Shutdown readiness';;
        14) printf '%s' 'Final certification';;
        *) printf 'Unknown step %s' "$1";;
    esac
}

scvmm_clean_field() {
    local v="$1"
    v="${v//$'\t'/ }"; v="${v//$'\n'/ }"; v="${v//$'\r'/ }"
    printf '%s' "$v"
}

record_result() {
    local id="$1" status="$2" message="$3" stamp tmp
    stamp="$(date -Is 2>/dev/null || date)"
    message="$(scvmm_clean_field "$message")"
    tmp="$(mktemp "$STATE_ROOT/.state.XXXXXX")" || return 1
    awk -F '\t' -v id="$id" '$1 != id' "$STATE_FILE" > "$tmp" || { rm -f "$tmp"; return 1; }
    printf '%s\t%s\t%s\t%s\n' "$id" "$status" "$stamp" "$message" >> "$tmp"
    chmod 600 "$tmp" 2>/dev/null || true
    mv -f -- "$tmp" "$STATE_FILE" || return 1
    scvmm_log "STEP_$id" "$status: $message"
}

get_status() { awk -F '\t' -v id="$1" '$1==id {s=$2} END {print s==""?"NOT RUN":s}' "$STATE_FILE"; }
get_message() { awk -F '\t' -v id="$1" '$1==id {m=$4} END {print m}' "$STATE_FILE"; }
get_timestamp() { awk -F '\t' -v id="$1" '$1==id {t=$3} END {print t}' "$STATE_FILE"; }

scvmm_invalidate_certification() {
    local status
    status="$(get_status 14)"
    if [[ "$status" != "NOT RUN" ]]; then
        record_result 14 WARN 'Certification invalidated because a preparation check was rerun or changed'
    fi
}

scvmm_load_modules() {
    local i action fn
    local -a matches
    for i in $(seq -w 1 "$STEP_COUNT"); do
        matches=( "$MODULE_ROOT/step${i}_"*.sh )
        if (( ${#matches[@]} != 1 )) || [[ ! -f "${matches[0]}" ]]; then
            printf 'ERROR: Missing or ambiguous module for step %s in %s\n' "$i" "$MODULE_ROOT" >&2
            return 1
        fi
        source "${matches[0]}" || return 1
        for action in audit fix verify; do
            fn="step${i}_${action}"
            declare -F "$fn" >/dev/null || { printf 'ERROR: %s does not define %s\n' "${matches[0]}" "$fn" >&2; return 1; }
        done
    done
    [[ -f "$MODULE_ROOT/step14_certification.sh" ]] || { printf 'ERROR: Missing Step 14 certification module\n' >&2; return 1; }
    source "$MODULE_ROOT/step14_certification.sh" || return 1
    declare -F step14_certify >/dev/null || { printf 'ERROR: Step 14 module must define step14_certify\n' >&2; return 1; }
}

run_step() {
    local id="$1" action="${2:-audit}" fn
    [[ "$id" =~ ^([1-9]|1[0-3])$ ]] || { printf 'Invalid preparation step: %s\n' "$id" >&2; return 2; }
    case "$action" in audit|fix|verify) ;; *) printf 'Invalid action: %s\n' "$action" >&2; return 2;; esac
    fn="step$(printf '%02d' "$id")_${action}"
    declare -F "$fn" >/dev/null || { printf 'ERROR: Module does not implement %s\n' "$fn" >&2; return 1; }
    scvmm_invalidate_certification
    STEP_STATUS=UNKNOWN; STEP_MESSAGE=''
    if ! "$fn"; then set_step_result FAIL "$action handler exited with an error"; fi
    [[ "$STEP_STATUS" != UNKNOWN ]] || set_step_result FAIL "$action handler did not return a result"
    record_result "$id" "$STEP_STATUS" "$STEP_MESSAGE" || return 1
    printf '%02d  %-7s  %s\n' "$id" "$STEP_STATUS" "$STEP_MESSAGE"
}

run_step_workflow() {
    local id="$1"
    run_step "$id" audit || return
    if [[ "$(get_status "$id")" != PASS ]]; then
        run_step "$id" fix || return
    fi
    run_step "$id" verify
}

audit_all() {
    local id rc=0
    for id in $(seq 1 "$STEP_COUNT"); do run_step "$id" audit || rc=1; done
    return "$rc"
}

certify_all() {
    audit_all || true
    STEP_STATUS=UNKNOWN; STEP_MESSAGE=''
    step14_certify || { [[ "$STEP_STATUS" == UNKNOWN ]] && set_step_result FAIL 'Certification handler failed'; }
    [[ "$STEP_STATUS" != UNKNOWN ]] || set_step_result FAIL 'Certification handler did not return a result'
    [[ "$STEP_STATUS" == PASS ]]
}

scvmm_color_status() {
    local status="$1" color='' reset=''
    if [[ -t 1 && "${NO_COLOR:-}" == '' ]]; then
        reset=$'\033[0m'
        case "$status" in PASS) color=$'\033[32m';; WARN) color=$'\033[33m';; FAIL) color=$'\033[31m';; *) color=$'\033[90m';; esac
    fi
    printf '%s%s%s' "$color" "$status" "$reset"
}

show_dashboard() {
    local i status message stamp pass=0 warn=0 fail=0 pending=0 os_name='unknown' host kernel arch readiness
    os_name="$(. /etc/os-release 2>/dev/null; printf '%s' "${PRETTY_NAME:-unknown}")"
    host="$(hostname 2>/dev/null || printf unknown)"; kernel="$(uname -r 2>/dev/null || printf unknown)"; arch="$(uname -m 2>/dev/null || printf unknown)"
    printf '\n%s  v%s\n' "$TOOL_NAME" "$TOOL_VERSION"
    printf 'Host: %s | OS: %s\nKernel: %s | Architecture: %s\n' "$host" "$os_name" "$kernel" "$arch"
    printf '%-4s %-7s %-37s %-19s %s\n' 'STEP' 'STATUS' 'CHECK' 'LAST RUN' 'DETAIL'
    printf 'Legend: %s / %s / %s / %s\n' "$(scvmm_color_status PASS)" "$(scvmm_color_status WARN)" "$(scvmm_color_status FAIL)" "$(scvmm_color_status 'NOT RUN')"
    printf '%s\n' '-----------------------------------------------------------------------------------------------'
    for i in $(seq 1 "$STEP_COUNT"); do
        status="$(get_status "$i")"; message="$(get_message "$i")"; stamp="$(get_timestamp "$i")"
        case "$status" in PASS) ((pass+=1));; WARN) ((warn+=1));; FAIL) ((fail+=1));; *) ((pending+=1));; esac
        [[ -n "$message" ]] || message='Not audited yet'
        [[ -n "$stamp" ]] || stamp='--'
        printf '%02d   ' "$i"
        scvmm_color_status "$status"
        printf ' %-37s %-19s %s\n' "$(step_name "$i")" "${stamp:0:19}" "$message"
    done
    status="$(get_status 14)"; message="$(get_message 14)"
    printf '%s\n' '-----------------------------------------------------------------------------------------------'
    printf 'TOTAL: %d PASS | %d WARN | %d FAIL | %d NOT RUN\n' "$pass" "$warn" "$fail" "$pending"
    printf 'STEP 14: %s  %s\n' "$(scvmm_color_status "$status")" "${message:-Not certified}"
    if (( fail > 0 )); then readiness='NOT READY - blocking issues found'
    elif (( warn > 0 || pending > 0 )); then readiness='NOT CERTIFIED - review or complete checks'
    elif [[ "$status" == PASS ]]; then readiness='CERTIFIED - all guest checks passed'
    else readiness='READY FOR CERTIFICATION - run Step 14'
    fi
    printf '\nREADINESS: %s\n\n' "$readiness"
}

confirm_action() {
    local prompt="$1" answer
    [[ "${SCVMM_ASSUME_YES:-0}" == 1 ]] && return 0
    [[ -t 0 ]] || { printf 'Confirmation required: %s (use --yes for the full workflow)\n' "$prompt" >&2; return 1; }
    read -r -p "$prompt [y/N]: " answer
    [[ "${answer,,}" == y || "${answer,,}" == yes ]]
}

reset_state() {
    local target="${1:-all}" tmp
    if [[ "$target" == all ]]; then
        tmp="$(mktemp "$STATE_ROOT/.reset.XXXXXX")" || return 1
        : > "$tmp"; mv -f -- "$tmp" "$STATE_FILE"
    else
        [[ "$target" =~ ^([1-9]|1[0-4])$ ]] || { printf 'Reset target must be 1-14 or all\n' >&2; return 2; }
        tmp="$(mktemp "$STATE_ROOT/.reset.XXXXXX")" || return 1
        awk -F '\t' -v id="$target" '$1 != id && !(id != 14 && $1 == 14)' "$STATE_FILE" > "$tmp" || { rm -f "$tmp"; return 1; }
        mv -f -- "$tmp" "$STATE_FILE"
    fi
    scvmm_log RESET "$target"; printf 'State reset: %s\n' "$target"
}
