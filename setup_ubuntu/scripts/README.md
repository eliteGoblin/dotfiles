# Setup Scripts

Utility scripts for Ubuntu VM setup and troubleshooting.

## Scripts

### fix_ssh_fonts.sh
**Purpose**: Fix SSH font rendering issues between macOS and Ubuntu VM

**Usage**:
```bash
./setup_ubuntu/scripts/fix_ssh_fonts.sh
```

**What it does**:
- Tests current SSH font rendering
- Verifies JetBrainsMono Nerd Font installation
- Configures proper environment variables for SSH sessions
- Tests nvim icons over SSH connection

**Requirements**:
- macOS terminal configured with "JetBrainsMono Nerd Font Mono"
- SSH access to Ubuntu VM configured
- JetBrainsMono Nerd Font installed on Ubuntu

**When to use**:
- Icons showing as blocks/squares in nvim over SSH
- Font rendering issues in terminal applications
- After setting up new Ubuntu VM or changing terminal fonts

### setup_time_sync.sh
**Purpose**: Configure NTP time synchronization on Ubuntu VM

**Usage** (run from macOS):
```bash
scp ~/.dotfiles/setup_ubuntu/scripts/setup_time_sync.sh ubuntu:~
ssh ubuntu 'chmod +x ~/setup_time_sync.sh && ~/setup_time_sync.sh'
```

**What it does**:
- Enables NTP via timedatectl
- Enables and starts systemd-timesyncd service
- Ensures service starts automatically on boot
- Verifies time sync is working

**When to use**:
- After creating a new Ubuntu VM
- If `timedatectl status` shows "NTP service: inactive"
- If time drifts after suspend/resume
- If SSL/TLS connections fail due to time mismatch