#!/usr/bin/env bash
step03_audit(){ if ! command -v cloud-init >/dev/null 2>&1; then set_step_result PASS 'cloud-init absent'; elif systemctl is-enabled cloud-init cloud-init-local cloud-config cloud-final 2>/dev/null | grep -q enabled; then set_step_result FAIL 'cloud-init units enabled; first-boot ownership conflict possible'; else set_step_result WARN 'cloud-init installed but appears disabled; verify clean/seed state'; fi; }
step03_fix(){ set_step_result WARN 'Remediation requires explicit review; no automatic change is made by this initial build'; }
step03_verify(){ step03_audit; }
