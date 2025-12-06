#!/bin/bash
set -euo pipefail

# Setup time synchronization for Ubuntu VM
# Run this script ON the Ubuntu VM (not macOS)

echo "=== Ubuntu VM Time Sync Setup ==="

# Check if running on Ubuntu
if [[ ! -f /etc/os-release ]] || ! grep -q "Ubuntu" /etc/os-release; then
    echo "ERROR: This script should be run on Ubuntu VM"
    exit 1
fi

echo "1. Enabling NTP via timedatectl..."
sudo timedatectl set-ntp true

echo "2. Enabling systemd-timesyncd service..."
sudo systemctl enable systemd-timesyncd
sudo systemctl start systemd-timesyncd

echo "3. Waiting for time sync..."
sleep 3

echo "4. Verifying configuration..."
echo
timedatectl status
echo

# Check sync status
if timedatectl status | grep -q "System clock synchronized: yes"; then
    echo "✓ Time sync is working correctly"
else
    echo "⚠ Time sync may not be working yet. Check 'timedatectl timesync-status'"
fi

if systemctl is-enabled systemd-timesyncd | grep -q "enabled"; then
    echo "✓ systemd-timesyncd will start on boot"
else
    echo "✗ systemd-timesyncd is NOT enabled for boot"
fi

echo
echo "=== Setup Complete ==="
echo "Time sync is now configured to persist across reboots."
echo
echo "To verify after suspend/resume, run:"
echo "  timedatectl status"
