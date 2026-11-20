#!/usr/bin/env bash
[[ -n "$STATE_ROOT" ]] || { if [[ "$(id -u)" == 0 ]]; then STATE_ROOT=/var/lib/scvmm-template; else STATE_ROOT="$HOME/.local/state/scvmm-template"; fi; }
[[ -n "$LOG_ROOT" ]] || { if [[ "$(id -u)" == 0 ]]; then LOG_ROOT=/var/log/scvmm-template; else LOG_ROOT="$HOME/.local/state/scvmm-template/log"; fi; }
STATE_FILE="$STATE_ROOT/steps.tsv"; ACTIVITY_LOG="$LOG_ROOT/activity.log"
init_paths(){ mkdir -p "$STATE_ROOT" "$LOG_ROOT" || exit 1; touch "$STATE_FILE" "$ACTIVITY_LOG" || exit 1; chmod 700 "$STATE_ROOT" "$LOG_ROOT" 2>/dev/null || true; }
set_step_result(){ STEP_STATUS="$1"; STEP_MESSAGE="$2"; }
step_name(){ case "$1" in
1) echo 'Base OS/kernel/Hyper-V integration';; 2) echo 'SCVMM guest agent';; 3) echo 'cloud-init specialization';; 4) echo 'SSH host identity';; 5) echo 'Machine ID';; 6) echo 'DHCP leases';; 7) echo 'NIC/network identity';; 8) echo 'Subscription identity';; 9) echo 'fstab';; 10) echo 'Logs/history';; 11) echo 'Agent logs';; 12) echo 'Disk reclamation';; 13) echo 'Shutdown readiness';; esac; }
record_result(){
 local id="$1" s="$2" m="$3" t
 t="$(mktemp "$STATE_ROOT/.step.XXXX")" || return 1
 awk -F '\t' -v i="$id" '$1!=i' "$STATE_FILE" > "$t"
 printf '%s\t%s\t%s\t%s\n' "$id" "$s" "$(date -Is)" "$m" >> "$t"
 mv "$t" "$STATE_FILE"
 if [[ "$id" != 14 ]]; then awk -F '\t' '$1!=14' "$STATE_FILE" > "$t"; mv "$t" "$STATE_FILE"; fi
 printf '%s\t%s\n' "$(date -Is)" "$id:$s:$m" >> "$ACTIVITY_LOG"
}
get_status(){ awk -F '\t' -v i="$1" '$1==i{s=$2} END{print s==""?"NOT RUN":s}' "$STATE_FILE"; }
get_message(){ awk -F '\t' -v i="$1" '$1==i{m=$4} END{print m}' "$STATE_FILE"; }
run_step(){
 local i="$1" action="${2:-audit}" fn
 fn="step$(printf '%02d' "$i")_$action"
 declare -F "$fn" >/dev/null || { echo "Missing action: $fn"; return 2; }
 STEP_STATUS=UNKNOWN; STEP_MESSAGE=; "$fn"
 [[ "$STEP_STATUS" != UNKNOWN ]] || set_step_result FAIL 'Action returned no result.'
 record_result "$i" "$STEP_STATUS" "$STEP_MESSAGE"
 printf '%02d %-7s %s\n' "$i" "$STEP_STATUS" "$STEP_MESSAGE"
}
show_dashboard(){
 local i s m p=0 w=0 f=0 n=0
 . /etc/os-release 2>/dev/null
 printf '%s v%s\nHost: %s | OS: %s | Kernel: %s | Arch: %s\n' "$TOOL_NAME" "$TOOL_VERSION" "$(hostname)" "${PRETTY_NAME:-unknown}" "$(uname -r)" "$(uname -m)"
 for i in $(seq 1 13); do
  s="$(get_status "$i")"; m="$(get_message "$i")"
  case "$s" in PASS)((p+=1));; WARN)((w+=1));; FAIL)((f+=1));; *) ((n+=1));; esac
  printf '%02d %-7s %-36s %s\n' "$i" "$s" "$(step_name "$i")" "$m"
 done
 printf 'Totals: %d PASS / %d WARN / %d FAIL / %d NOT RUN | Step 14: %s\n' "$p" "$w" "$f" "$n" "$(get_status 14)"
 if ((f)); then echo 'READINESS: NOT READY'; elif ((w||n)); then echo 'READINESS: NOT CERTIFIED'; else echo 'READINESS: ALL CHECKS PASS'; fi
}
