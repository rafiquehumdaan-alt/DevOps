#!/bin/bash 

echo "Press 1 to check disk usage"
echo "Press 2 to check system uptime"
echo "Press 3 to list users"
read -rp "Enter your choice [1-3]: " choice

case $choice in
    1)
        echo "Disk Usage:"
        df -h
        ;;
    2)
        echo "System Uptime:"
        uptime
        ;;
    3)
        echo "List of Users:"
        cut -d: -f1 /etc/passwd
        ;;

    *)
        echo "Invalid choice"
        ;;
esac