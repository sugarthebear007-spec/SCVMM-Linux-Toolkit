#!/usr/bin/env bash
step02_audit(){ local found=0; for p in /usr/sbin/scvmmguestagent /usr/bin/scvmmguestagent /opt/microsoft/scvmmagent /var/opt/microsoft/scvmmagent; do [[ -e "$p" ]] && found=1; done; if ((found)); then set_step_result WARN 'Agent path found; validate version and real VMM guest operations'; else set_step_result FAIL 'SCVMM Linux guest agent not found in common locations'; fi; }
step02_fix(){ set_step_result WARN 'Remediation requires explicit review; no automatic change is made by this initial build'; }
step02_verify(){ step02_audit; }
