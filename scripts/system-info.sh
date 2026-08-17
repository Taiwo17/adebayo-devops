#!/bin/bash

echo "=========================="
echo "Adebayo System Information"
echo "=========================="

echo "Current User:"
whoami

echo "Hostname:"
hostname

echo "Kernel:"
uname -r

echo "Operating System:"
cat /etc/os-release | grep PRETTY_NAME

echo "IP Address:"
hostname -I

echo "System Uptime:"
uptime -p
