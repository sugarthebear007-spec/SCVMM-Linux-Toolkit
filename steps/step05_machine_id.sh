#!/usr/bin/env bash
step05_audit(){ if [[ ! -e /etc/machine-id || -s /etc/machine-id ]]; then set_step_result FAIL '/etc/machine-id missing or populated; must be zero-length for clone regeneration'; elif [[ -L /var/lib/dbus/machine-id && "$(readlink /var/lib/dbus/machine-id)" == /etc/machine-id ]]; then set_step_result PASS 'Empty machine-id and canonical D-Bus symlink'; else set_step_result WARN 'machine-id empty but D-Bus symlink not canonical'; fi; }
step05_fix(){ set_step_result WARN 'Remediation requires explicit review; no automatic change is made by this initial build'; }
step05_verify(){ step05_audit; }
