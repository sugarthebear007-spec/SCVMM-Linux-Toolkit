#!/usr/bin/env bash
step09_audit(){ if awk '!/^[[:space:]]*#/ && NF>=2 && $1 ~ /^\/dev\/sd[a-z]/ {bad=1} END{exit !bad}' /etc/fstab 2>/dev/null; then set_step_result FAIL 'fstab contains /dev/sdX references; use UUID/LABEL'; else set_step_result PASS 'No /dev/sdX fstab entries detected'; fi; }
step09_fix(){ set_step_result WARN 'Remediation requires explicit review; no automatic change is made by this initial build'; }
step09_verify(){ step09_audit; }
