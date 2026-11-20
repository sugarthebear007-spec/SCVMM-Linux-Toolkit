#!/usr/bin/env bash
step10_audit(){ local n=0 f; for f in /var/log/wtmp /var/log/btmp /var/log/lastlog /root/.bash_history; do [[ -s "$f" ]] && ((n+=1)); done; if ((n)); then set_step_result WARN "$n login/history files contain data; review before generalization"; else set_step_result PASS 'Common login/history files empty or absent'; fi; }
step10_fix(){ set_step_result WARN 'Remediation requires explicit review; no automatic change is made by this initial build'; }
step10_verify(){ step10_audit; }
