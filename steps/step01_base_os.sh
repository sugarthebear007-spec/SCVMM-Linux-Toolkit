#!/usr/bin/env bash
step01_audit(){ local os; os="$(. /etc/os-release 2>/dev/null; echo "${PRETTY_NAME:-unknown}")"; if [[ "$os" == unknown ]]; then set_step_result FAIL 'Cannot identify OS'; elif grep -Eqi 'hv_vmbus|hv_storvsc|hv_netvsc' /proc/modules 2>/dev/null; then set_step_result PASS "$os; Hyper-V modules detected"; else set_step_result WARN "$os; confirm LIS modules (built-in modules may not show in /proc/modules)"; fi; }
step01_fix(){ set_step_result WARN 'Remediation requires explicit review; no automatic change is made by this initial build'; }
step01_verify(){ step01_audit; }
