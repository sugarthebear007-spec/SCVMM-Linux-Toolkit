# Version 3.0 check map

1 Base OS/kernel/Hyper-V integration. 2 SCVMM Linux guest agent. 3 cloud-init specialization ownership. 4 SSH host identity. 5 machine ID. 6 DHCP lease state. 7 NIC/network identity. 8 subscription identity. 9 fstab. 10 logs/history. 11 agent logs. 12 disk reclamation. 13 shutdown readiness. 14 final guest certification.

Audit is read-only. Remediation is separate and requires review, confirmation, backup/rollback, and independent verification. Only PASS is accepted by Step 14. Guest-side certification cannot prove SCVMM library import or clone uniqueness. External validation must import/publish the VHDX, deploy two simultaneous VMs, and confirm distinct hostnames, machine IDs, SSH host keys, and network identities.
