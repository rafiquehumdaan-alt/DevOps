#!/bin/bash

TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
LOG_FILE="system_monitor_$TIMESTAMP.log"

{
    echo "System Monitor Report"
    echo "Generated on: $(date)"
    echo "--------------------------------"

    echo ""
    echo "CPU Usage:"
    top -bn1 | grep "Cpu"

    echo ""
    echo "Memory Usage:"
    free -h

    echo ""
    echo "Disk Usage:"
    df -h

    echo ""
    echo "Top 5 Processes by Memory:"
    ps aux --sort=-%mem | head -n 6

} > "$LOG_FILE"

cat "$LOG_FILE"

echo ""
echo "System monitor report saved to: $LOG_FILE"