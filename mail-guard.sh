#!/bin/bash
# mail-guard.sh — ensure mail services stay dead on Virtualmin boxes
# Run via cron: @reboot /usr/local/bin/mail-guard.sh
#               0 * * * * /usr/local/bin/mail-guard.sh
#
# Exit 0: all quiet
# Exit 1: something was running and got stopped

SERVICES="postfix dovecot clamav-daemon clamav-freshclam spamassassin amavis amavisd-new opendkim"
FIXED=0
HOST=$(hostname -s)

for svc in $SERVICES; do
    # Skip if not installed
    systemctl list-unit-files "${svc}.service" &>/dev/null || continue

    # Check if enabled (survives reboot)
    if systemctl is-enabled "${svc}.service" &>/dev/null; then
        systemctl disable "${svc}.service" 2>/dev/null
        echo "${HOST}: disabled ${svc}"
        FIXED=1
    fi

    # Check if running right now
    if systemctl is-active "${svc}.service" &>/dev/null; then
        systemctl stop "${svc}.service" 2>/dev/null
        echo "${HOST}: stopped ${svc}"
        FIXED=1
    fi
done

if [ $FIXED -eq 0 ]; then
    exit 0
else
    # Pipe this output to notification however you like
    exit 1
fi
