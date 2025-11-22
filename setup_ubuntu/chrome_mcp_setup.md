# Chrome MCP Setup and Troubleshooting

## Overview
Enable Ubuntu VM to access Chrome DevTools on macOS for Claude MCP (Model Context Protocol) integration.

## Architecture
```
┌──────────────────────────────────────────────────────┐
│ macOS Host (172.20.10.2 on hotspot)                  │
│                                                       │
│  Chrome + DevTools: 127.0.0.1:9222                  │
│  socat proxy: 172.20.10.2:9223 → 127.0.0.1:9222     │
│  /etc/hosts: 172.20.10.3 myubuntu (Ubuntu VM)       │
└──────────────────────────────────────────────────────┘
                       │
                Bridge Network
                       │
┌──────────────────────────────────────────────────────┐
│ Ubuntu VM (172.20.10.3 on hotspot)                   │
│                                                       │
│  Claude Desktop + MCP                                │
│  Connects to: http://myubuntu:9223                   │
│  /etc/hosts: 172.20.10.2 myubuntu (macOS)           │
└──────────────────────────────────────────────────────┘
```

## Network IP Changes
IPs change when switching networks:

| Network       | macOS IP      | Ubuntu VM IP  |
|---------------|---------------|---------------|
| Home WiFi     | 192.168.4.2   | 192.168.4.3   |
| Phone Hotspot | 172.20.10.2   | 172.20.10.3   |
| Office WiFi   | 10.x.x.2      | 10.x.x.3      |

**Both machines need `/etc/hosts` updated after network changes.**

## Setup Commands

### One-Command Setup (from macOS)

After switching networks, run **one command** on macOS that does everything:

```bash
# 1. Start Chrome MCP first (if not running)
run_chrome_mcp start

# 2. Sync IPs bidirectionally (macOS ↔ Ubuntu)
sync_mac_ip sync
```

This automatically:
- ✅ Updates macOS `~/.ssh/config` (ubuntu hostname)
- ✅ Updates macOS `/etc/hosts` (myubuntu → Ubuntu IP)
- ✅ Updates Ubuntu `/etc/hosts` (mymac → macOS IP) **via SSH**
- ✅ Verifies Chrome MCP is running
- ✅ Tests Chrome MCP connectivity from Ubuntu
- ✅ Flushes DNS cache

### Check Status

```bash
run_chrome_mcp status    # Check Chrome MCP
sync_mac_ip status       # Check IP sync (both directions)
```

`sync_mac_ip status` shows:
- macOS → Ubuntu: SSH config and /etc/hosts
- Ubuntu → macOS: /etc/hosts and Chrome MCP accessibility

## Troubleshooting

### Issue: "Could not resolve host: mymac" on Ubuntu

**Cause**: Ubuntu's `/etc/hosts` doesn't have macOS IP

**Solution**:
```bash
# On macOS - run sync to update Ubuntu's /etc/hosts
sync_mac_ip sync

# OR manually on Ubuntu (if SSH isn't working)
echo '172.20.10.2 mymac' | sudo tee -a /etc/hosts

# Verify
curl http://mymac:9223/json/version
```

### Issue: "Connection refused" from Ubuntu

**Causes**:
1. Chrome MCP not running on macOS
2. macOS firewall blocking connections
3. Wrong IP in Ubuntu's `/etc/hosts`

**Solutions**:
```bash
# On macOS
run_chrome_mcp status  # Check if running
run_chrome_mcp start   # Start if not running

# On Ubuntu
curl http://172.20.10.2:9223/json/version  # Test with IP directly
```

### Issue: socat listening on old IP (192.x instead of 172.x)

**Cause**: Network changed but Chrome MCP not restarted

**Solution**:
```bash
# On macOS
run_chrome_mcp stop
run_chrome_mcp start

# Verify new IP
run_chrome_mcp status | grep "172.20.10.2:9223"
```

### Issue: "Cannot ping mymac" on Ubuntu

**Cause**: macOS firewall blocks ICMP ping (this is normal)

**Solution**: Use HTTP test instead of ping:
```bash
# This will FAIL (expected)
ping mymac

# This should WORK
curl http://mymac:9223/json/version
```

### Issue: MCP shows old IP in logs

**Cause**: Need to sync IPs after network change

**Solution** (simple, one command):
```bash
# On macOS - restart Chrome MCP then sync
run_chrome_mcp stop
run_chrome_mcp start
sync_mac_ip sync

# That's it! sync_mac_ip updates Ubuntu's /etc/hosts automatically
```

## Quick Reference

### After switching networks (WiFi ↔ hotspot ↔ office):

```bash
# On macOS - TWO commands, that's it!
run_chrome_mcp stop && run_chrome_mcp start
sync_mac_ip sync

# Everything is now configured automatically
# - macOS knows Ubuntu's new IP
# - Ubuntu knows macOS's new IP
# - Chrome MCP connectivity verified
```

### Verification checklist:

```bash
# On macOS - check everything
run_chrome_mcp status   # Should show "HEALTHY"
sync_mac_ip status      # Should show "All systems in sync"
```

This verifies:
- [ ] macOS SSH config has Ubuntu IP
- [ ] macOS /etc/hosts has `myubuntu` → Ubuntu IP
- [ ] Ubuntu /etc/hosts has `mymac` → macOS IP
- [ ] Ubuntu can reach Chrome MCP at `http://mymac:9223`

## File Locations

### macOS
- `~/.local/bin/run_chrome_mcp` - Chrome MCP management script
- `~/.local/bin/sync_mac_ip` - Bidirectional IP sync script
- `~/.ssh/config` - SSH config (auto-updated by sync_mac_ip)
- `/etc/hosts` - Hostname resolution (auto-updated by sync_mac_ip)
- `~/.chrome-mcp-profile` - Chrome DevTools profile
- `~/.creds/local.sh` - Contains `UBUNTU_SUDO_PASSWORD` env var

### Ubuntu
- `/etc/hosts` - Hostname resolution (auto-updated by sync_mac_ip via SSH)

## Hostnames Explained

- **myubuntu**: On macOS, points to Ubuntu VM (172.20.10.3)
- **mymac**: On Ubuntu, points to macOS host (172.20.10.2)

This makes it clear which machine you're referring to:
```bash
# From macOS
ssh ubuntu               # or ssh parallels@myubuntu

# From Ubuntu
curl http://mymac:9223   # Access Chrome MCP on macOS
```

## Requirements

For `sync_mac_ip` to work, you need:

1. **Chrome MCP running**: `run_chrome_mcp start`
2. **SSH access to Ubuntu**: `ssh ubuntu` must work
3. **Ubuntu sudo password**: Set `UBUNTU_SUDO_PASSWORD` env var in `~/.creds/local.sh`
4. **Parallels Tools**: Installed on Ubuntu VM (for prlctl)

## Future Improvements

1. Add network change hooks to auto-run sync scripts
2. Document Claude MCP configuration on Ubuntu
3. Auto-start Chrome MCP if not running during sync
