#!/usr/bin/env bash
#
#============================================================
# SCVMM LINUX TEMPLATE PREPARATION MANAGER
# Version: 2.0
# Platform: Ubuntu Server
# SCVMM: 2025 UR1
#
# MASTER PROJECT FILE
#
# IMPORTANT:
# - Project notes are maintained in this file.
# - Each step has independent audit/fix/verify functions.
# - Replace only the relevant NOTES and STEP sections.
# - Do not rebuild the entire script for individual fixes.
# - Audits are read-only.
# - Remediation requires confirmation.
#============================================================


#============================================================
# SECTION A - PROJECT PROGRESSION NOTES
#
# THIS IS OUR PERMANENT PROJECT RECORD.
# UPDATE EACH STEP AS WE MAKE PROGRESS.
#
#============================================================

# PROJECT OBJECTIVE:
# Prepare a clean Ubuntu Linux VM template for deployment
# through Microsoft System Center Virtual Machine Manager.
#
# WORKING METHOD:
# 1. Investigate one step at a time.
# 2. Record findings below.
# 3. Develop remediation for that step only.
# 4. Verify the result.
# 5. Update the progression notes.
# 6. Continue to the next step.
#
#
#============================================================

# PERMANENT CHANGE AND SESSION HANDOFF PROCEDURE
# ALL FUTURE CORRECTIONS USE TWO SMALL REPLACEMENT PASTES.
# PASTE 1 - PROJECT NOTES
# - Updated notes for the affected step only.
# - Record findings, completed work, outstanding work,
# decisions and next action.
# PASTE 2 - STEP CODE
# - Updated code for the affected step only.
# - Replace the corresponding function/section.
# RULES:
# - Never replace the entire manager for an ordinary fix.
# - Never change unrelated steps without a reason.
# - Preserve all existing verified progress.
# - Update the project notes after every completed action.
# - Keep the 14-step numbering permanent.
# - Every session must use this file as its handoff record.
# - If a major redesign requires a complete replacement,
# explain why before providing it.
# SESSION RESTART:
# When starting a new ChatGPT session, provide this file
# or its current contents.
# Continue from CURRENT WORKING STEP and CURRENT TASK.
# Do not restart completed work unnecessarily.
# 
#
#============================================================
# 
# SESSION HANDOFF AND CONTINUITY RULES
# PROJECT: SCVMM LINUX TEMPLATE PREPARATION
# MANAGER VERSION: 2.0
# TOTAL PROJECT STEPS: 14
# CURRENT POSITION:
# Step 1 - SCVMM Guest Agent Investigation
# CURRENT OBJECTIVE:
# Resolve the SCVMM Guest Agent initialization failure.
# CONFIRMED FINDINGS:
# - Ubuntu Server installation is operational.
# - SCVMM Guest Agent is installed.
# - Agent service is enabled.
# - Agent executable is present.
# - Agent attempts to retrieve configuration from CD/DVD.
# - No CD/DVD filesystem is currently mounted.
# - Agent cannot find linuxosconfiguration.xml.
# - Agent exits after unsuccessful initialization.
# - /etc/machine-id is currently empty.
# - hostnamectl reports: No medium found.
# - DBus machine-id points to /etc/machine-id.
# IMPORTANT INVESTIGATION RULES:
# - Do not assume the CD/DVD is the underlying problem.
# - Do not manufacture missing specialization files.
# - Do not reinstall or upgrade the agent without evidence.
# - Preserve diagnostic logs until Step 1 is resolved.
# - Distinguish an installed agent from a functioning agent.
# WORKING ENVIRONMENT:
# - Ubuntu Server 26.04
# - Microsoft SCVMM 2025 UR1
# - Manager: /tmp/scvmm-linux-template-manager.sh
# - Agent: /opt/microsoft/scvmmguestagent
# - Agent log: /var/opt/microsoft/scvmmguestagent/log/scvmm.log
# - Installer log: /var/opt/microsoft/scvmmguestagent/log/scvmm-install.log
# SESSION START INSTRUCTIONS:
# 1. Read Section A before doing anything.
# 2. Identify CURRENT WORKING STEP.
# 3. Review the last findings and outstanding actions.
# 4. Continue from the last confirmed position.
# 5. Do not repeat completed investigations unnecessarily.
# 6. Ask for command output only when needed.
# 7. Never assume an unverified operation succeeded.
# COMPLETION STANDARD:
# A step is complete only when its intended result
# has been verified and its progression notes updated.
# FINAL PROJECT REQUIREMENT:
# Produce a clean, reusable Ubuntu template suitable
# for deployment and specialization through SCVMM.
# 
#============================================================
#
#============================================================
#============================================================
# STEP 1 - VMM GUEST AGENT
#============================================================
# STATUS: INVESTIGATION - DEPLOYMENT BEHAVIOR TO VERIFY
#
# DONE:
# - Agent installed.
# - Installation directory and executable identified.
# - Architecture confirmed x64.
# - Service enabled.
# - SysV initialization script examined.
# - Agent executable examined.
# - Configuration examined.
# - Installation and agent logs examined.
# - Read-only media inventory completed.
#
# CONFIRMED FINDINGS:
# - Ubuntu 26.04.1 LTS.
# - Kernel 7.0.0-43-generic.
# - Agent metadata version: 1.0.4.1032.
# - Executable log build: 1.0.3-1023.
# - Executable SHA256 recorded.
# - Executable is not registered in dpkg.
# - Service uses generated SysV initialization.
# - Service reports active (exited).
# - No persistent agent process remains.
# - Agent attempts to obtain configuration from ISO.
# - /dev/cdrom is detected by the executable.
# - Mount operation fails with error 123.
# - No optical filesystem or volume is detected.
# - linuxosconfiguration.xml cannot be found.
# - Agent exits after unsuccessful initialization.
#
# NEW INVESTIGATION FINDING:
# Microsoft documentation indicates that the
# specialization log is created during VM deployment
# and specialization.
#
# The missing ISO on the preparation VM does not
# independently establish an agent installation failure.
#
# OUTSTANDING:
# - Establish whether this VM is a source template
#   or an already deployed SCVMM guest.
# - Verify SCVMM deployment and specialization behavior.
# - Verify the guest OS compatibility requirements.
# - Confirm installed agent package provenance.
# - Establish whether version metadata and executable
#   build are consistent.
#
# DECISIONS:
# - Do not manufacture specialization XML.
# - Do not manually attach an arbitrary ISO.
# - Do not reinstall the agent without evidence.
# - Preserve existing diagnostic logs.
# - Do not modify machine ID during this investigation.
#
# NEXT ACTION:
# Establish VM deployment context and inspect the
# corresponding SCVMM specialization configuration.
#
#============================================================
#============================================================
# STEP 2 - SPECIALIZATION / CLOUD-INIT
#============================================================
# STATUS: VERIFY
#
# DONE:
# - Existing manager checks cloud-init marker.
#
# NEXT:
# - Verify which component owns first-boot specialization.
# - Confirm SCVMM/cloud-init interaction.
# - Confirm final cloud-init configuration.
#
#============================================================
# STEP 3 - SSH HOST KEYS
#============================================================
# STATUS: VERIFY REGENERATION
#
# DONE:
# - Existing host key detection reviewed.
#
# NEXT:
# - Verify automatic first-boot key regeneration.
# - Only then approve removal of template host keys.
#
#============================================================
# STEP 4 - MACHINE ID
#============================================================
# STATUS: TEMPLATE STATE - VERIFY
#
# DONE:
# - /etc/machine-id inspected.
# - File is zero bytes.
# - Permissions are 0444.
# - systemd-id128 machine-id reported:
#   Failed to get machine-ID: No medium found
# - hostnamectl also reported No medium found.
#
# IMPORTANT:
# An empty machine ID can be intentional at final
# template preparation, but it is not a healthy live
# operating state for normal system operation.
#
# NEXT:
# - Verify machine ID regeneration after deployment.
# - Verify hostnamectl and systemd functionality.
# - Only approve final empty state at template shutdown.
#
#============================================================
# STEP 5 - DBUS MACHINE ID
#============================================================
# STATUS: VERIFIED - VERIFY WITH MACHINE ID
#
# DONE:
# - /var/lib/dbus/machine-id is a symlink.
# - Symlink points to /etc/machine-id.
#
#============================================================
# STEP 6 - DHCP LEASE STATE
#============================================================
# STATUS: PASS - REVERIFY BEFORE FINALIZATION
#
#============================================================
# STEP 7 - PERSISTENT NIC NAMING
#============================================================
# STATUS: PASS - REVERIFY BEFORE FINALIZATION
#
#============================================================
# STEP 8 - LOGS AND HISTORY
#============================================================
# STATUS: ACTION REQUIRED
#
# NEXT:
# - Review login records.
# - Review journal storage.
# - Review shell history.
# - Clean only after retaining required diagnostic logs.
#
#============================================================
# STEP 9 - SCVMM AGENT LOGS
#============================================================
# STATUS: VERIFY LOCATION
#
# VERIFIED DIRECTORY:
# /var/opt/microsoft/scvmmguestagent/log
#
# VERIFIED FILES:
# - scvmm-install.log
# - scvmm.log
#
# IMPORTANT:
# Preserve diagnostic logs while Step 1 is unresolved.
#
#============================================================
# STEP 10 - SUBSCRIPTION IDENTITY
#============================================================
# STATUS: PASS - VERIFY
#
#============================================================
# STEP 11 - FSTAB UUID / LABEL
#============================================================
# STATUS: PASS - VERIFY
#
#============================================================
# STEP 12 - NIC CONFIGURATION
#============================================================
# STATUS: DEFERRED
#
# DECISION:
# Networking will be configured through SCVMM/PowerShell.
#
#============================================================
# STEP 13 - DISK PREPARATION
#============================================================
# STATUS: VERIFY TRIM
#
#============================================================
# STEP 14 - SHUTDOWN READINESS
#============================================================
# STATUS: PENDING
#
# DEPENDENCIES:
# - All required steps verified.
# - SCVMM agent issue resolved.
# - Machine ID behavior confirmed.
# - Network deployment plan confirmed.
# - Checkpoints reviewed in SCVMM.
# - Final graceful shutdown.
#
#============================================================
# PROJECT PROGRESSION RECORD
#
# CURRENT WORKING STEP: 1
# CURRENT TASK: SCVMM AGENT INVESTIGATION
#
# LAST KNOWN WORKING FILE:
# /tmp/scvmm-linux-template-manager.sh
#
#============================================================


#============================================================
# SECTION B - MANAGER CONFIGURATION
#============================================================

set -uo pipefail

VERSION="2.0"
APP="SCVMM Linux Template Preparation Manager"

LOG_DIR="/var/log/scvmm-template"
STATE_DIR="/var/lib/scvmm-template"

mkdir -p "$LOG_DIR" "$STATE_DIR" || {
    echo "Cannot create manager directories."
    exit 1
}

chmod 700 "$STATE_DIR"

LOG_FILE="$LOG_DIR/template-manager.log"

touch "$LOG_FILE"
chmod 600 "$LOG_FILE"


#============================================================
# GENERAL FUNCTIONS
#============================================================

log() {
    printf '[%s] %s\n' \
        "$(date '+%F %T')" "$*" | tee -a "$LOG_FILE"
}

pause() {
    echo
    read -r -p "Press ENTER to continue..." _
}

confirm() {
    local answer
    read -r -p "$1 [y/N]: " answer
    [[ "$answer" =~ ^([Yy]|[Yy][Ee][Ss])$ ]]
}

run() {
    log "COMMAND: $*"
    "$@"
    local rc=$?
    log "EXIT CODE: $rc"
    return "$rc"
}

show_heading() {
    echo
    echo "============================================================"
    echo "$1"
    echo "============================================================"
}

#============================================================
# STEP NAMES
#============================================================

step_name() {
    case "$1" in
        1) echo "VMM Guest Agent" ;;
        2) echo "Specialization / cloud-init" ;;
        3) echo "SSH host keys" ;;
        4) echo "Machine ID" ;;
        5) echo "DBus machine ID" ;;
        6) echo "DHCP lease state" ;;
        7) echo "Persistent NIC naming" ;;
        8) echo "Logs and history" ;;
        9) echo "SCVMM agent logs" ;;
        10) echo "Subscription identity" ;;
        11) echo "fstab UUID / LABEL" ;;
        12) echo "NIC configuration" ;;
        13) echo "Disk preparation" ;;
        14) echo "Shutdown readiness" ;;
        *) echo "Unknown step" ;;
    esac
}


#============================================================
# SECTION C - LIVE STATUS DETECTION
#============================================================

step_status() {
    local n="$1"

    case "$n" in

    1)
        if [[ -x /opt/microsoft/scvmmguestagent/bin/scvmmguestagent.bin ]]; then
            echo "INVESTIGATION"
        else
            echo "ACTION REQUIRED"
        fi
        ;;

    2)
        if [[ -f /etc/cloud/cloud-init.disabled ]]; then
            echo "VERIFY SPECIALIZATION"
        else
            echo "ACTION REQUIRED"
        fi
        ;;

    3)
        if compgen -G "/etc/ssh/ssh_host_*_key" >/dev/null; then
            echo "VERIFY REGENERATION"
        else
            echo "KEYS ABSENT - VERIFY"
        fi
        ;;

    4)
        if [[ -f /etc/machine-id ]] &&
           [[ ! -s /etc/machine-id ]]; then
            echo "EMPTY - TEMPLATE STATE"
        elif [[ -s /etc/machine-id ]]; then
            echo "POPULATED - VERIFY"
        else
            echo "ACTION REQUIRED"
        fi
        ;;

    5)
        if [[ -L /var/lib/dbus/machine-id ]] &&
           [[ "$(readlink /var/lib/dbus/machine-id)" == "/etc/machine-id" ]]; then
            echo "PASS - SYMLINK"
        else
            echo "VERIFY"
        fi
        ;;

    6)
        if find /var/lib/dhclient /var/lib/dhcp \
            /var/lib/NetworkManager -maxdepth 2 -type f \
            \( -name '*.lease' -o -name '*.leases' \
            -o -name 'dhclient*' \) 2>/dev/null | grep -q .; then
            echo "ACTION REQUIRED"
        else
            echo "PASS - NO MATCHING LEASES"
        fi
        ;;

    7)
        if [[ -f /etc/udev/rules.d/70-persistent-net.rules ]]; then
            echo "ACTION REQUIRED"
        else
            echo "PASS - NO LEGACY RULE"
        fi
        ;;

    8)
        local dirty=0

        for f in /var/log/wtmp /var/log/btmp /var/log/lastlog; do
            [[ -s "$f" ]] && dirty=1
        done

        [[ -s /root/.bash_history ]] && dirty=1

        if [[ -d /var/log/journal ]] &&
           find /var/log/journal -type f -size +0c \
           2>/dev/null | grep -q .; then
            dirty=1
        fi

        if [[ "$dirty" -eq 1 ]]; then
            echo "ACTION REQUIRED"
        else
            echo "VERIFY"
        fi
        ;;

    9)
        if [[ -d /var/opt/microsoft/scvmmguestagent/log ]]; then
            echo "VERIFY LOGS"
        else
            echo "LOCATION NOT FOUND"
        fi
        ;;

    10)
        if command -v pro >/dev/null 2>&1; then
            if pro status 2>/dev/null | grep -qi "not attached"; then
                echo "PASS - NOT ATTACHED"
            else
                echo "VERIFY SUBSCRIPTION"
            fi
        else
            echo "NOT APPLICABLE"
        fi
        ;;

    11)
        if grep -Ev '^[[:space:]]*(#|$)' /etc/fstab |
           grep -Eq '^[[:space:]]*/dev/sd'; then
            echo "ACTION REQUIRED"
        else
            echo "PASS - NO DIRECT SD REFERENCES"
        fi
        ;;

    12)
        echo "DEFERRED"
        ;;

    13)
        echo "VERIFY TRIM"
        ;;

    14)
        echo "PENDING"
        ;;

    *)
        echo "UNKNOWN"
        ;;

    esac
}


#============================================================
# STATUS DISPLAY
#============================================================

show_status() {
    echo
    echo "============================================================"
    echo "              SCVMM TEMPLATE PREPARATION STATUS"
    echo "============================================================"

    local i

    for i in {1..14}; do
        printf "Step %-2s : %-27s : %s\n" \
            "$i" \
            "$(step_name "$i")" \
            "$(step_status "$i")"
    done

    echo "============================================================"
}


#============================================================
# SECTION D - INDIVIDUAL STEP DEFINITIONS
#
# EACH STEP IS INDEPENDENT.
#
# WHEN UPDATING A STEP:
# 1. Replace its progression notes above.
# 2. Replace its function section below.
#
# DO NOT CHANGE THE MANAGER ENGINE.
#============================================================


#============================================================
# STEP 1 - VMM GUEST AGENT
#============================================================


#============================================================
# STEP 1 - VMM GUEST AGENT
#============================================================

step1_audit() {
    show_heading "STEP 1 - VMM GUEST AGENT INVESTIGATION"

    local base="/opt/microsoft/scvmmguestagent"
    local exe="$base/bin/scvmmguestagent.bin"
    local logdir="/var/opt/microsoft/scvmmguestagent/log"

    echo "1. OPERATING SYSTEM"
    echo "----------------------------"
    cat /etc/os-release 2>&1 || true
    uname -a

    echo
    echo "2. AGENT VERSION METADATA"
    echo "----------------------------"
    cat "$base/etc/version" 2>&1 || true
    cat "$base/etc/buildarch" 2>&1 || true

    echo
    echo "3. EXECUTABLE INFORMATION"
    echo "----------------------------"
    ls -l "$exe" 2>&1 || true
    file "$exe" 2>&1 || true
    sha256sum "$exe" 2>&1 || true

    echo
    echo "4. EXECUTABLE VERSION OUTPUT"
    echo "----------------------------"
    echo "Version/help options are not assumed."
    echo "No executable arguments will be supplied automatically."

    echo
    echo "5. AGENT CONFIGURATION"
    echo "----------------------------"
    find "$base/etc" -maxdepth 2 -type f \
        -printf '%p\n' 2>&1 || true

    echo
    cat "$base/etc/scvmm.conf" 2>&1 || true

    echo
    echo "6. INITIALIZATION SCRIPT"
    echo "----------------------------"
    sed -n '1,240p' /etc/init.d/scvmmguestagent \
        2>&1 || true

    echo
    echo "7. SPECIALIZATION REFERENCES"
    echo "----------------------------"
    grep -RaniE \
        'linuxosconfiguration|specialization|iso9660|cdrom|sr0|mount' \
        "$base/etc" /etc/init.d/scvmmguestagent \
        2>/dev/null || true

    echo
    echo "8. AGENT PACKAGE REGISTRATION"
    echo "----------------------------"
    dpkg-query -S "$exe" 2>&1 || true

    echo
    echo "9. SERVICE STATE"
    echo "----------------------------"
    systemctl status scvmmguestagent \
        --no-pager 2>&1 || true

    systemctl is-enabled scvmmguestagent 2>&1 || true

    echo
    echo "10. RUNNING PROCESSES"
    echo "----------------------------"
    pgrep -af scvmmguestagent || true

    echo
    echo "11. MEDIA DEVICE INFORMATION"
    echo "----------------------------"
    lsblk -o NAME,TYPE,FSTYPE,LABEL,UUID,MOUNTPOINTS

    echo
    findmnt -rn -t iso9660,udf 2>&1 || true

    echo
    echo "12. AGENT LOGS"
    echo "----------------------------"
    tail -80 "$logdir/scvmm.log" 2>&1 || true

    echo
    echo "13. INSTALLATION LOG"
    echo "----------------------------"
    tail -60 "$logdir/scvmm-install.log" 2>&1 || true

    echo
    echo "STEP 1 READ-ONLY INVESTIGATION COMPLETE."
}

step1_fix() {
    show_heading "STEP 1 - AGENT REMEDIATION"

    echo "No remediation is authorized."
    echo
    echo "Outstanding investigation:"
    echo "- Confirm executable/build compatibility."
    echo "- Establish Ubuntu 26.04 support."
    echo "- Establish expected specialization media structure."
    echo "- Establish SCVMM configuration delivery behavior."
    echo
    echo "Preserve all existing diagnostic logs."
}

step1_verify() {
    show_heading "STEP 1 - AGENT VERIFICATION"

    echo "Agent process:"
    pgrep -af scvmmguestagent || true

    echo
    echo "Service status:"
    systemctl status scvmmguestagent \
        --no-pager 2>&1 || true

    echo
    echo "Recent initialization errors:"
    grep -iE 'error|exception|failed|linuxosconfiguration' \
        /var/opt/microsoft/scvmmguestagent/log/scvmm.log \
        2>/dev/null | tail -40 || true

    echo
    echo "Machine identity:"
    wc -c /etc/machine-id 2>&1 || true

    echo
    echo "Verification does not imply successful initialization."
}


#============================================================
# STEP 2 - SPECIALIZATION / CLOUD-INIT
#============================================================

step2_audit() {
    show_heading "STEP 2 - SPECIALIZATION / CLOUD-INIT"

    dpkg-query -W cloud-init 2>/dev/null || true

    echo
    ls -l /etc/cloud/cloud-init.disabled 2>/dev/null || true

    echo
    for s in cloud-init-local cloud-init cloud-config cloud-final; do
        echo "$s:"
        systemctl is-enabled "$s" 2>/dev/null || true
    done

    echo
    cloud-init status --long 2>&1 || true

    echo
    echo "Netplan configuration:"
    ls -la /etc/netplan/ 2>/dev/null || true
}

step2_fix() {
    show_heading "STEP 2 - CLOUD-INIT REMEDIATION"

    echo "Cloud-init ownership must be established first."
    echo "Do not disable specialization until the SCVMM"
    echo "deployment mechanism has been confirmed."
    echo
    echo "No automatic changes authorized."
}

step2_verify() {
    step2_audit
}


#============================================================
# STEP 3 - SSH HOST KEYS
#============================================================

step3_audit() {
    show_heading "STEP 3 - SSH HOST KEYS"

    ls -la /etc/ssh/ssh_host_* 2>/dev/null || true

    echo
    systemctl status ssh.service --no-pager 2>&1 || true

    echo
    grep -RniE 'ssh-keygen -A|ssh_host_' \
        /usr/lib/systemd/system /etc/systemd/system \
        2>/dev/null || true
}

step3_fix() {
    show_heading "STEP 3 - SSH HOST KEY CLEANUP"

    echo "Verify first-boot key generation before removal."

    if confirm "Have you verified automatic regeneration?"; then
        if confirm "Remove existing SSH host keys?"; then
            run rm -f /etc/ssh/ssh_host_*
        fi
    fi
}

step3_verify() {
    step3_audit
}


#============================================================
# STEP 4 - MACHINE ID
#============================================================

step4_audit() {
    show_heading "STEP 4 - MACHINE ID"

    echo "/etc/machine-id:"
    ls -l /etc/machine-id 2>&1 || true
    wc -c /etc/machine-id 2>&1 || true

    echo
    echo "systemd machine ID:"
    systemd-id128 machine-id 2>&1 || true

    echo
    echo "Hostname:"
    hostnamectl --static 2>&1 || true

    echo
    echo "Machine ID regeneration configuration:"
    grep -RniE 'machine-id|systemd-machine-id-setup' \
        /usr/lib/systemd/system /etc/systemd/system \
        2>/dev/null | head -40 || true
}

step4_fix() {
    show_heading "STEP 4 - MACHINE ID"

    echo "Machine ID handling depends on deployment stage."
    echo
    echo "An empty machine ID is a possible final template state."
    echo "It is not a healthy normal operating state."
    echo
    echo "No automatic modification authorized."
}

step4_verify() {
    step4_audit
}


#============================================================
# STEP 5 - DBUS MACHINE ID
#============================================================

step5_audit() {
    show_heading "STEP 5 - DBUS MACHINE ID"

    ls -la /var/lib/dbus/machine-id 2>&1 || true
    readlink /var/lib/dbus/machine-id 2>&1 || true

    echo
    echo "Machine ID target:"
    ls -l /etc/machine-id 2>&1 || true
}

step5_fix() {
    show_heading "STEP 5 - DBUS MACHINE ID REPAIR"

    if confirm "Create DBus machine-id symlink to /etc/machine-id?"; then
        run install -d -m 0755 /var/lib/dbus || return
        run rm -f /var/lib/dbus/machine-id || return
        run ln -s /etc/machine-id /var/lib/dbus/machine-id
    fi
}

step5_verify() {
    step5_audit
}


#============================================================
# STEP 6 - DHCP LEASE STATE
#============================================================

step6_audit() {
    show_heading "STEP 6 - DHCP LEASE STATE"

    for d in /var/lib/dhclient /var/lib/dhcp \
             /var/lib/NetworkManager; do
        echo
        echo "Directory: $d"
        find "$d" -maxdepth 2 -type f 2>/dev/null || true
    done
}

step6_fix() {
    show_heading "STEP 6 - DHCP LEASE CLEANUP"

    echo "Review the lease files before deletion."

    if confirm "Remove matching DHCP lease files?"; then
        for d in /var/lib/dhclient /var/lib/dhcp \
                 /var/lib/NetworkManager; do
            [[ -d "$d" ]] || continue

            find "$d" -maxdepth 2 -type f \
                \( -name '*.lease' -o -name '*.leases' \
                -o -name 'dhclient*' \) \
                -print -delete
        done
    fi
}

step6_verify() {
    step6_audit
}


#============================================================
# STEP 7 - PERSISTENT NIC NAMING
#============================================================

step7_audit() {
    show_heading "STEP 7 - PERSISTENT NIC NAMING"

    ls -la /etc/udev/rules.d/70-persistent-net.rules \
        2>/dev/null || echo "No legacy persistent NIC rule found."

    echo
    echo "Network interfaces:"
    ip -br link 2>&1 || true

    echo
    echo "Udev rules:"
    ls -la /etc/udev/rules.d/ 2>/dev/null || true
}

step7_fix() {
    show_heading "STEP 7 - PERSISTENT NIC CLEANUP"

    local f="/etc/udev/rules.d/70-persistent-net.rules"

    if [[ -f "$f" ]]; then
        if confirm "Remove legacy persistent NIC naming rule?"; then
            run rm -f "$f"
        fi
    else
        echo "No matching file exists."
    fi
}

step7_verify() {
    step7_audit
}


#============================================================
# STEP 8 - LOGS AND HISTORY
#============================================================

step8_audit() {
    show_heading "STEP 8 - LOGS AND HISTORY"

    echo "Login logs:"
    ls -lah /var/log/wtmp /var/log/btmp \
        /var/log/lastlog 2>&1 || true

    echo
    echo "Journal storage:"
    journalctl --disk-usage 2>&1 || true

    echo
    echo "Root history:"
    ls -lah /root/.bash_history 2>&1 || true

    echo
    echo "Temporary directories:"
    ls -lah /tmp /var/tmp 2>&1 || true
}

step8_fix() {
    show_heading "STEP 8 - LOG AND HISTORY CLEANUP"

    echo "WARNING: This operation removes historical records."
    echo "Preserve required diagnostic information first."

    if confirm "Proceed with login log and history cleanup?"; then

        for f in /var/log/wtmp /var/log/btmp /var/log/lastlog; do
            [[ -f "$f" ]] && run truncate -s 0 "$f"
        done

        if command -v journalctl >/dev/null 2>&1; then
            run journalctl --rotate
            run journalctl --vacuum-time=1s
        fi

        if [[ -f /root/.bash_history ]]; then
            run rm -f /root/.bash_history
        fi

        echo
        echo "Cleanup completed."
        echo "Temporary directories were not deleted."
    fi
}

step8_verify() {
    step8_audit
}


#============================================================
# STEP 9 - SCVMM AGENT LOGS
#============================================================

step9_audit() {
    show_heading "STEP 9 - SCVMM AGENT LOGS"

    local d="/var/opt/microsoft/scvmmguestagent/log"

    echo "Expected log directory:"
    ls -ld "$d" 2>&1 || true

    echo
    echo "Agent log files:"
    find "$d" -maxdepth 2 -type f -ls 2>/dev/null || true

    echo
    echo "Recent agent log:"
    tail -60 "$d/scvmm.log" 2>&1 || true

    echo
    echo "Recent installation log:"
    tail -40 "$d/scvmm-install.log" 2>&1 || true
}

step9_fix() {
    show_heading "STEP 9 - SCVMM AGENT LOG CLEANUP"

    echo "Agent logs are currently required for Step 1."
    echo "Do not delete them while agent investigation continues."
    echo
    echo "Cleanup will be considered after Step 1 is resolved."
}

step9_verify() {
    step9_audit
}


#============================================================
# STEP 10 - SUBSCRIPTION IDENTITY
#============================================================

step10_audit() {
    show_heading "STEP 10 - SUBSCRIPTION IDENTITY"

    if command -v pro >/dev/null 2>&1; then
        pro status 2>&1 || true
    else
        echo "Ubuntu Pro client not installed."
    fi
}

step10_fix() {
    show_heading "STEP 10 - SUBSCRIPTION CLEANUP"

    if ! command -v pro >/dev/null 2>&1; then
        echo "Ubuntu Pro client not installed."
        return
    fi

    pro status

    echo
    echo "Detach only if this source VM is attached."

    if confirm "Detach this VM from Ubuntu Pro?"; then
        run pro detach
    fi
}

step10_verify() {
    step10_audit
}


#============================================================
# STEP 11 - FSTAB UUID / LABEL
#============================================================

step11_audit() {
    show_heading "STEP 11 - FSTAB VERIFICATION"

    cat /etc/fstab

    echo
    echo "Filesystem UUIDs:"
    blkid 2>&1 || true

    echo
    echo "Checking direct /dev/sd references:"

    if grep -Ev '^[[:space:]]*(#|$)' /etc/fstab |
       grep -E '^[[:space:]]*/dev/sd'; then
        echo "ACTION REQUIRED."
    else
        echo "No direct /dev/sd references found."
    fi
}

step11_fix() {
    show_heading "STEP 11 - FSTAB"

    echo "No automatic fstab modification."
    echo
    echo "Review persistent filesystem references."
    echo "Prefer UUID= or LABEL= where appropriate."
    echo "Verify boot behavior before changing anything."
}

step11_verify() {
    step11_audit
}


#============================================================
# STEP 12 - NIC CONFIGURATION
#============================================================

step12_audit() {
    show_heading "STEP 12 - NIC CONFIGURATION"

    echo "Network configuration is intentionally deferred."

    echo
    ip -br address 2>&1 || true

    echo
    ip route 2>&1 || true

    echo
    ls -la /etc/netplan/ 2>&1 || true

    echo
    echo "No networking changes will be made."
}

step12_fix() {
    show_heading "STEP 12 - NETWORK CONFIGURATION"

    echo "DEFERRED."
    echo
    echo "SCVMM/PowerShell will handle deployment networking."
    echo "Do not modify Netplan at this stage."
}

step12_verify() {
    step12_audit
}


#============================================================
# STEP 13 - DISK PREPARATION
#============================================================

step13_audit() {
    show_heading "STEP 13 - DISK PREPARATION"

    echo "Disk usage:"
    df -h

    echo
    echo "Block devices:"
    lsblk -f

    echo
    echo "Mounted filesystems:"
    findmnt

    echo
    echo "fstrim availability:"
    command -v fstrim || true

    echo
    echo "Discard support:"
    lsblk -D 2>&1 || true

    echo
    echo "TRIM has not been performed by this audit."
}

step13_fix() {
    show_heading "STEP 13 - DISK TRIM"

    if ! command -v fstrim >/dev/null 2>&1; then
        echo "fstrim is unavailable."
        return
    fi

    echo "fstrim issues discard requests to supported filesystems."
    echo "It does not delete ordinary files."

    if confirm "Run fstrim -av?"; then
        run fstrim -av
    fi
}

step13_verify() {
    step13_audit
}


#============================================================
# STEP 14 - SHUTDOWN READINESS
#============================================================

step14_audit() {
    show_heading "STEP 14 - SHUTDOWN READINESS"

    echo "Hostname:"
    hostnamectl --static 2>&1 || true

    echo
    echo "Machine ID:"
    wc -c /etc/machine-id 2>&1 || true

    echo
    echo "SSH host keys:"
    ls /etc/ssh/ssh_host_* 2>/dev/null || true

    echo
    echo "Mounted filesystems:"
    findmnt

    echo
    echo "SCVMM agent process:"
    pgrep -af scvmmguestagent || true

    echo
    echo "FINAL MANUAL CHECKS:"
    echo "- All required steps verified."
    echo "- SCVMM deployment configuration verified."
    echo "- Checkpoints reviewed in SCVMM."
    echo "- No unwanted saved state."
    echo "- No unresolved work."
    echo "- VM ready for graceful shutdown."
}

step14_fix() {
    show_heading "STEP 14 - FINAL SHUTDOWN"

    echo "This is the final operation."
    echo
    echo "Confirm all other steps are complete."
    echo "Confirm checkpoints have been reviewed in SCVMM."
    echo "Confirm no further work is required."
    echo
    echo "This operation shuts down the current VM."

    if confirm "Gracefully shut down this VM now?"; then
        log "FINAL VM SHUTDOWN REQUESTED."
        shutdown -h now
    fi
}

step14_verify() {
    step14_audit
}


#============================================================
# SECTION E - STEP DISPATCHER
#============================================================

audit_step() {
    case "$1" in
        1) step1_audit ;;
        2) step2_audit ;;
        3) step3_audit ;;
        4) step4_audit ;;
        5) step5_audit ;;
        6) step6_audit ;;
        7) step7_audit ;;
        8) step8_audit ;;
        9) step9_audit ;;
        10) step10_audit ;;
        11) step11_audit ;;
        12) step12_audit ;;
        13) step13_audit ;;
        14) step14_audit ;;
        *) echo "Invalid step." ;;
    esac
}

fix_step() {
    case "$1" in
        1) step1_fix ;;
        2) step2_fix ;;
        3) step3_fix ;;
        4) step4_fix ;;
        5) step5_fix ;;
        6) step6_fix ;;
        7) step7_fix ;;
        8) step8_fix ;;
        9) step9_fix ;;
        10) step10_fix ;;
        11) step11_fix ;;
        12) step12_fix ;;
        13) step13_fix ;;
        14) step14_fix ;;
        *) echo "Invalid step." ;;
    esac
}

verify_step() {
    case "$1" in
        1) step1_verify ;;
        2) step2_verify ;;
        3) step3_verify ;;
        4) step4_verify ;;
        5) step5_verify ;;
        6) step6_verify ;;
        7) step7_verify ;;
        8) step8_verify ;;
        9) step9_verify ;;
        10) step10_verify ;;
        11) step11_verify ;;
        12) step12_verify ;;
        13) step13_verify ;;
        14) step14_verify ;;
        *) echo "Invalid step." ;;
    esac
}


#============================================================
# SECTION F - INDIVIDUAL STEP MENU
#============================================================

individual_step() {
    local n choice

    read -r -p "Enter step number (1-14): " n

    if ! [[ "$n" =~ ^([1-9]|1[0-4])$ ]]; then
        echo "Invalid step."
        return
    fi

    while true; do
        echo
        show_heading "STEP $n - $(step_name "$n")"

        echo "CURRENT STATUS: $(step_status "$n")"
        echo
        echo "1. Inspect / Audit"
        echo "2. Remediate / Perform action"
        echo "3. Verify results"
        echo "4. Return to main menu"
        echo

        read -r -p "Selection: " choice

        case "$choice" in
            1)
                audit_step "$n"
                log "Step $n audit performed."
                pause
                ;;
            2)
                fix_step "$n"
                log "Step $n remediation reviewed."
                pause
                ;;
            3)
                verify_step "$n"
                log "Step $n verification performed."
                pause
                ;;
            4)
                return
                ;;
            *)
                echo "Invalid selection."
                ;;
        esac
    done
}


#============================================================
# SECTION G - COMPLETE AUDIT
#============================================================

complete_audit() {
    local i

    for i in {1..14}; do
        audit_step "$i"
        echo
    done

    show_status

    log "Complete 14-step audit performed."

    pause
}


#============================================================
# SECTION H - PROJECT NOTES VIEWER
#============================================================

view_project_notes() {
    show_heading "PROJECT PROGRESSION NOTES"

    echo "The complete progression record is stored"
    echo "at the beginning of this manager script."

    echo
    sed -n '1,250p' "$0"

    pause
}


#============================================================
# SECTION I - ACTIVITY LOG
#============================================================

view_activity_log() {
    show_heading "ACTIVITY LOG"

    if [[ -s "$LOG_FILE" ]]; then
        less "$LOG_FILE"
    else
        echo "No activity recorded."
    fi

    pause
}


#============================================================
# SECTION J - MAIN MENU
#============================================================

main_menu() {
    local choice

    while true; do

        clear 2>/dev/null || true

        echo
        echo "============================================================"
        echo " $APP"
        echo " Version $VERSION"
        echo "============================================================"

        show_status

        echo
        echo "MAIN MENU"
        echo "------------------------------------------------------------"
        echo "1. Run complete audit (read-only)"
        echo "2. Select individual step"
        echo "3. Refresh status"
        echo "4. View activity log"
        echo "5. View project progression notes"
        echo "6. Exit"
        echo

        read -r -p "Select option: " choice

        case "$choice" in
            1)
                complete_audit
                ;;
            2)
                individual_step
                ;;
            3)
                continue
                ;;
            4)
                view_activity_log
                ;;
            5)
                view_project_notes
                ;;
            6)
                log "Manager closed."
                exit 0
                ;;
            *)
                echo "Invalid selection."
                sleep 1
                ;;
        esac
    done
}


#============================================================
# SECTION K - STARTUP
#============================================================

if [[ "$EUID" -ne 0 ]]; then
    echo
    echo "Please run as root:"
    echo "sudo bash $0"
    exit 1
fi

log "Starting $APP version $VERSION"

main_menu
