# SCVMM Linux Template Preparation Manager 3.0

Modular Linux guest-side readiness assessor for golden VHDX preparation.

Audit functions do not alter guest configuration; only manager state and activity logs are written. Fix functions are separate and advisory in this initial build. Destructive identity scrubbing, subscription deregistration, NIC changes, history deletion, disk trim, and shutdown require explicit operator review.

PASS means the implemented assertion succeeded. WARN means manual/environment-specific validation remains. FAIL means a blocking condition was detected. Step 14 certifies guest-side checks only; SCVMM library import and two simultaneous clone deployments must be validated in SCVMM. The manager never shuts down the VM automatically.

Run with Bash 4+: chmod +x manager.sh && ./manager.sh. Options: --dashboard, --audit, --step N, --certify, --help. Dashboard refresh is every 30 seconds.

Steps 1-13: base OS/LIS; VMM agent; cloud-init ownership; SSH keys; machine ID; DHCP leases; NIC identity; subscription identity; fstab; logs/history; agent logs; disk reclamation; shutdown readiness. Step 14 re-assesses all checks and certifies only if every result is PASS.

Root state defaults: /var/lib/scvmm-template and /var/log/scvmm-template. Non-root state defaults: ~/.local/state/scvmm-template. Override with SCVMM_STATE_ROOT and SCVMM_LOG_ROOT.

This is the first 3.0 framework commit. Fix routines need distro-aware backup/rollback and explicit confirmation before implementation. The supplied instruction document currently ends at Shut Down Cleanly; detailed shutdown, library publication, and two-clone validation procedures remain to be completed.
