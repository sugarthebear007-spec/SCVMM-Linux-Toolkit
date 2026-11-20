#!/usr/bin/env bash
step14_certify(){ local i s bad=0; for i in $(seq 1 13); do s="$(get_status "$i")"; [[ "$s" == PASS ]] || ((bad+=1)); done
if ((bad)); then set_step_result FAIL "Certification withheld: $bad checks are not PASS"; else set_step_result PASS 'Guest checks 1-13 passed; SCVMM library import and two-clone test are external validation gates'; fi
record_result 14 "$STEP_STATUS" "$STEP_MESSAGE"; printf '14 %-7s %s\n' "$STEP_STATUS" "$STEP_MESSAGE"; }
