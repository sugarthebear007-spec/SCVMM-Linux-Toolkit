#!/usr/bin/env bash
step13_audit(){ if command -v pgrep >/dev/null 2>&1 && pgrep -af 'apt|dpkg|dnf|yum|zypper|packagekit' 2>/dev/null | grep -v pgrep | grep -q .; then set_step_result FAIL 'Package manager active; finish updates before shutdown'; elif [[ -e /var/run/reboot-required ]]; then set_step_result WARN 'Reboot pending; reboot and re-audit'; else set_step_result WARN 'No package manager detected; shutdown remains an operator action'; fi; }
step13_fix(){ set_step_result WARN 'Remediation requires explicit review; no automatic change is made by this initial build'; }
step13_verify(){ step13_audit; }
