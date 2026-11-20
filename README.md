# SCVMM Linux Template Preparation Manager 3.0

A modular, guest-side tool for auditing and preparing Linux VMs for use as SCVMM library templates. It does not publish templates to SCVMM or perform clone-deployment validation.

## Operating modes

- **New install** (`./manager.sh --new-install --yes`): run the audit for each of the 13 preparation steps; invoke that step's repair handler when the audit is not PASS; independently verify it; then run Step 14 certification. `--yes` confirms the complete workflow. Individual repair handlers must still be designed to be safe, distro-aware, and explicit about consequential changes.
- **Existing VM** (`./manager.sh --existing-vm`): audit the VM as it was received and run final certification. It does not invoke repair handlers. Review the dashboard, repair only what is approved, then rerun the assessment.
- **Interactive dashboard** (`./manager.sh`): color-coded live view with menu-driven audits, step actions, workflows, certification, and reset controls.

## Dashboard status

- **Green / PASS** — the step's implemented checks passed.
- **Yellow / WARN** — review or manual/environment-specific validation is still needed.
- **Red / FAIL** — a blocking condition was detected.
- **Gray / NOT RUN** — no result has been recorded yet.

Certification is strict: Step 14 passes only when all 13 current audits return PASS. WARN, FAIL, and NOT RUN prevent certification. Re-running a preparation check invalidates an earlier certification. Saved results support the dashboard and audit trail; certification always starts with fresh audits.

The dashboard automatically redraws every 30 seconds. That refresh is display-only: it does not run audits or modify the VM. Use **Audit all** or **Certify** to request checks.

## Engine and step-module contract

- `manager.sh` — command line, interactive dashboard, mode orchestration, confirmation prompts.
- `variables.sh` — portable settings and environment overrides.
- `lib.sh` — module loading, status colors, state, logging, dispatch, reset, and certification orchestration.
- `steps/stepNN_*.sh` — step-specific `stepNN_audit`, `stepNN_fix`, and `stepNN_verify` functions. Step 14 provides `step14_certify`.

Audit functions must be read-only with respect to guest configuration. Fix functions are separate and may only make changes explicitly authorized by the selected workflow. Verify functions must perform a fresh check after a repair; they must not merely report the saved audit result. Step modules communicate through `set_step_result PASS|WARN|FAIL "message"`.

The engine is designed to be frozen after its independent tests pass. Normal feature work after that point should be limited to the individual step modules, not changes to the manager, shared library, or configuration interface.

## Commands

```bash
./manager.sh                         # interactive dashboard
./manager.sh --existing-vm            # audit + certify, no repairs
./manager.sh --new-install --yes      # full new-install workflow
./manager.sh --audit                  # run all read-only audits
./manager.sh --step 5 audit           # audit one step
./manager.sh --step 5 fix             # confirm, run repair, then verify
./manager.sh --step 5 workflow        # confirm, audit/fix/verify as needed
./manager.sh --certify                # fresh audit of all 13 + Step 14
./manager.sh --reset 5                # reset one step and its certification
./manager.sh --reset all              # reset all saved results
```

Run with Bash 4 or newer. State and activity logs default to `/var/lib/scvmm-template` and `/var/log/scvmm-template` when run as root, or `$XDG_STATE_HOME/scvmm-template` for a non-root user. Override with `SCVMM_STATE_ROOT`, `SCVMM_LOG_ROOT`, and `SCVMM_MODULE_ROOT`. `SCVMM_REFRESH_SECONDS` controls the dashboard redraw interval. Set `NO_COLOR=1` to disable ANSI colors.

The manager never shuts down the VM automatically. Disk reclaim, identity scrubbing, subscription deregistration, network changes, history deletion, and shutdown must be treated as controlled, separately reviewed operations. Step 14 certifies guest-side checks only; SCVMM library import and two-clone validation remain external SCVMM tasks.
