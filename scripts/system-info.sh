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
grep PRETTY_NAME /etc/os-release

echo "IP Address:"
hostname -I

echo "System Uptime:"
uptime -p

if
