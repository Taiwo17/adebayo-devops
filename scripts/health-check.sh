#!/bin/bash

echo "=========================="
echo "Adebayo Server Health Check"
echo "=========================="

echo "Hostname:"
hostname

echo "Disk Usage:"
df -h /

echo "Memory:"
free -h

echo "System Uptime:"
uptime -p
