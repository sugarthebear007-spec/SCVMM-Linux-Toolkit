#!/usr/bin/env bash
step04_audit(){ local n; n="$(find /etc/ssh -maxdepth 1 -type f -name 'ssh_host_*' 2>/dev/null | wc -l)"; if ((n)); then set_step_result WARN "$n SSH host-key files remain; remove only during confirmed final generalization"; else set_step_result PASS 'No SSH host keys found'; fi; }
step04_fix(){ set_step_result WARN 'Remediation requires explicit review; no automatic change is made by this initial build'; }
step04_verify(){ step04_audit; }
