#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
MODULES="$TMP/steps"; mkdir -p "$MODULES"
for i in $(seq -w 1 13); do
cat > "$MODULES/step${i}_test.sh" <<'MODULE'
step01_audit(){ set_step_result "${TEST_STEP01_STATUS:-PASS}" 'synthetic audit'; }
step01_fix(){ set_step_result PASS 'synthetic repair'; }
step01_verify(){ set_step_result PASS 'synthetic verification'; }
MODULE
sed -i "s/step01_/step${i}_/g" "$MODULES/step${i}_test.sh"
done
cat > "$MODULES/step14_certification.sh" <<'MODULE'
step14_certify(){
    local i s bad=0
    for i in $(seq 1 13); do s="$(get_status "$i")"; [[ "$s" == PASS ]] || ((bad+=1)); done
    if ((bad)); then set_step_result FAIL "Certification withheld: $bad checks are not PASS"; else set_step_result PASS 'All synthetic checks passed'; fi
    record_result 14 "$STEP_STATUS" "$STEP_MESSAGE"
    printf '14  %-7s  %s\n' "$STEP_STATUS" "$STEP_MESSAGE"
}
MODULE
export SCVMM_STATE_ROOT="$TMP/state" SCVMM_LOG_ROOT="$TMP/log" SCVMM_MODULE_ROOT="$MODULES" SCVMM_ASSUME_YES=1
"$ROOT/manager.sh" --audit > "$TMP/audit.out"
grep -q 'TOTAL: 13 PASS | 0 WARN | 0 FAIL | 0 NOT RUN' "$TMP/audit.out"
"$ROOT/manager.sh" --certify > "$TMP/cert.out"
grep -q 'STEP 14: PASS' "$TMP/cert.out"
"$ROOT/manager.sh" --step 2 fix > "$TMP/fix.out"
grep -q '02  PASS' "$TMP/fix.out"
grep -q 'synthetic verification' "$TMP/state/steps.tsv"
"$ROOT/manager.sh" --reset 2 > "$TMP/reset.out"
if grep -q $'^14\t' "$TMP/state/steps.tsv"; then echo 'FAIL: reset did not clear certification' >&2; exit 1; fi
TEST_STEP01_STATUS=WARN "$ROOT/manager.sh" --existing-vm > "$TMP/existing.out" || true
grep -q 'STEP 14: FAIL' "$TMP/existing.out"
"$ROOT/manager.sh" --new-install --yes > "$TMP/new.out" || true
grep -q 'STEP 14: PASS' "$TMP/new.out"
echo 'PASS: engine syntax, audit dispatch, fix/verify dispatch, state reset, existing-VM certification, and new-install workflow'
