#!/bin/bash

# Snipped from XYZ
CPU_USAGE=$(top -b -n2 -p 1 | fgrep "Cpu(s)" | tail -1 | awk -F'id,' -v prefix="$prefix" '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); printf "%s%.1f%%\n", prefix, 100 - v }')
DATE=$(date "+%Y-%m-%d %H:%M:")
LOAD="$DATE CPU: $CPU_USAGE"

# Set Max Load for Ifelse
MAX="90"

# Append to Logpath
echo $LOAD >> /var/log/cpus_usage

# Send over external Telegram Bot API Script
if (( $(echo "${CPU_USAGE::-1} > $MAX" |bc -l) )); then
/tgapi/sendovertelegramapi "Current Usage: $CPU_USAGE"
fi