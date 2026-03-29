# Chrome MCP Cross-Machine Setup

## Overview

This documents the Chrome MCP (Model Context Protocol) pattern for running Claude Code on an Ubuntu VM with browser automation powered by Chrome running on macOS. This enables Claude to control a real Chrome browser on the Mac from inside the VM.

## Architecture

```
┌──────────────────────────────────────────────────────────────┐
│ macOS Host (e.g. 192.168.4.25)                               │
│                                                               │
│  Chrome --remote-debugging-port=9222                         │
│    └─ Listens on 127.0.0.1:9222 (localhost only)             │
│    └─ Profile: ~/.chrome-mcp-profile (separate from main)    │
│                                                               │
│  socat proxy                                                  │
│    └─ LAN_IP:9223 → 127.0.0.1:9222                          │
│    └─ Exposes Chrome DevTools to LAN                         │
│                                                               │
│  Scripts:                                                     │
│    ~/.local/bin/run_chrome_mcp  (Chrome + socat lifecycle)   │
│    ~/.local/bin/dev_sync        (IP sync, MCP config update) │
└──────────────────────────────────────────────────────────────┘
                       │
               Parallels Bridge Network
                       │
┌──────────────────────────────────────────────────────────────┐
│ Ubuntu VM (e.g. 192.168.4.27)                                │
│                                                               │
│  Claude Code CLI                                              │
│    └─ MCP server: chrome-devtools                            │
│    └─ Connects to: http://<MAC_IP>:9223                      │
│                                                               │
│  ~/.claude.json (mcpServers config)                          │
│  ~/.local/bin/npx-mcp (NPX wrapper for corp registry bypass)│
└──────────────────────────────────────────────────────────────┘
```

**Data flow**: Claude Code (Ubuntu) → chrome-devtools-mcp (NPX) → HTTP → socat (Mac LAN:9223) → Chrome DevTools (Mac 127.0.0.1:9222)

## New Machine Setup

### Prerequisites

- macOS with Parallels Desktop and an Ubuntu VM
- Both machines on the same bridge network (Parallels handles this)
- SSH access from Mac to Ubuntu VM configured

### Step 1: Mac — Install dependencies

```bash
# socat (for proxying Chrome DevTools to LAN)
brew install socat

# Google Chrome (if not already installed)
# Download from https://www.google.com/chrome/
```

### Step 2: Mac — Install run_chrome_mcp script

```bash
# From the dotfiles repo
cp util/run_chrome_mcp ~/.local/bin/run_chrome_mcp
chmod +x ~/.local/bin/run_chrome_mcp

# Verify
run_chrome_mcp help
```

The script manages:
- Chrome instance with `--remote-debugging-port=9222` using a dedicated profile (`~/.chrome-mcp-profile`)
- socat proxy binding to `LAN_IP:9223` forwarding to `127.0.0.1:9222`
- PID tracking in `~/.chrome-mcp/` with health checks

Commands:
```bash
run_chrome_mcp start     # Start Chrome + socat
run_chrome_mcp stop      # Stop both
run_chrome_mcp status    # Health check
run_chrome_mcp restart   # Stop + start (use after network change)
```

### Step 3: Mac — Install dev_sync script

```bash
cp util/dev_sync ~/.local/bin/dev_sync
chmod +x ~/.local/bin/dev_sync
```

Edit the config section at the top of `dev_sync` to match your environment:
```bash
VM_NAME="Ubuntu"           # Parallels VM name
VM_USER="parallels"        # Ubuntu username
MAC_HOSTNAME="mymac"       # Hostname for Mac in Ubuntu's /etc/hosts
UBUNTU_HOSTNAME="myubuntu" # Hostname for Ubuntu in Mac's /etc/hosts
SSH_CONFIG_HOST="ubuntu"   # SSH config host alias
```

Also configure:
```bash
# In ~/.creds/local.sh (sourced by dev_sync)
export UBUNTU_SUDO_PASSWORD="your-ubuntu-password"
```

### Step 4: Ubuntu VM — Install Node.js

```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ~/.bashrc

# Install Node 22+
nvm install 22
nvm use 22
node --version  # Should be v22.x
```

### Step 5: Ubuntu VM — Create npx-mcp wrapper

If your corporate network blocks `registry.npmjs.org`, create a wrapper that uses the public registry:

```bash
mkdir -p ~/.local/bin
cat > ~/.local/bin/npx-mcp << 'EOF'
#!/bin/bash
export PATH="$HOME/.nvm/versions/node/v22.20.0/bin:$PATH"
export npm_config_registry="https://registry.npmjs.org/"
exec npx "$@"
EOF
chmod +x ~/.local/bin/npx-mcp
```

Update the Node.js path if your version differs (`ls ~/.nvm/versions/node/`).

If your network doesn't block npm, you can skip this and use `npx` directly in the MCP config.

### Step 6: Ubuntu VM — Configure Claude MCP

Add the `chrome-devtools` MCP server to `~/.claude.json`:

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "type": "stdio",
      "command": "/home/parallels/.local/bin/npx-mcp",
      "args": [
        "chrome-devtools-mcp@latest",
        "--browserUrl=http://<MAC_IP>:9223"
      ],
      "env": {}
    }
  }
}
```

Replace `<MAC_IP>` with the Mac's current LAN IP. The `dev_sync` script will keep this updated automatically when IPs change.

If you skipped the npx-mcp wrapper (Step 5), use `"command": "npx"` instead.

### Step 7: Start everything

```bash
# On Mac:
run_chrome_mcp start   # Start Chrome + socat proxy
dev_sync sync          # Sync IPs and verify MCP connectivity

# Verify:
run_chrome_mcp status  # Should show HEALTHY
dev_sync status        # Should show Chrome MCP accessible
```

### Step 8: Test from Ubuntu

```bash
# On Ubuntu VM:
curl http://<MAC_IP>:9223/json/version   # Should return Chrome version JSON

# Start Claude Code - it will auto-connect to Chrome MCP
claude
```

## Daily Workflow

### After Mac sleep/wake or network change

```bash
# On Mac:
run_chrome_mcp restart   # Rebind socat to new LAN IP
dev_sync sync            # Sync IPs, update Ubuntu MCP config, verify
```

### If VM becomes unreachable after Mac sleep

`dev_sync sync` handles this automatically — it detects unreachable VM and performs a Parallels suspend/resume to re-establish the bridge network.

### Check status

```bash
run_chrome_mcp status    # Chrome + socat health
dev_sync status          # Full status: IPs, SSH, Chrome MCP, services
```

## How dev_sync Keeps It Working

The `dev_sync` script handles all the moving parts when IPs change:

1. Detects Mac LAN IP and Ubuntu VM IP (via `prlctl`)
2. Updates Mac's `~/.ssh/config` with Ubuntu's IP
3. Updates Mac's `/etc/hosts` (`myubuntu` → Ubuntu IP)
4. Updates Ubuntu's `/etc/hosts` (`mymac` → Mac IP) via SSH
5. Updates Ubuntu's `~/.claude.json` MCP config with Mac's current IP
6. Verifies Chrome MCP is reachable from Ubuntu
7. Auto-recovers unreachable VM via suspend/resume

## File Locations

### macOS
| File | Purpose |
|------|---------|
| `~/.local/bin/run_chrome_mcp` | Chrome + socat lifecycle management |
| `~/.local/bin/dev_sync` | IP sync, MCP config update, VM recovery |
| `~/.chrome-mcp/` | State dir (PIDs, logs) |
| `~/.chrome-mcp-profile/` | Dedicated Chrome profile for MCP |
| `~/.ssh/config` | SSH alias for Ubuntu VM (auto-updated) |
| `/etc/hosts` | `myubuntu` hostname (auto-updated) |
| `~/.creds/local.sh` | `UBUNTU_SUDO_PASSWORD` env var |

### Ubuntu VM
| File | Purpose |
|------|---------|
| `~/.claude.json` | MCP servers config (auto-updated by dev_sync) |
| `~/.local/bin/npx-mcp` | NPX wrapper (bypasses corp registry) |
| `/etc/hosts` | `mymac` hostname (auto-updated by dev_sync) |

## Troubleshooting

### "Connection refused" from Ubuntu to Mac:9223

1. Check Chrome MCP is running: `run_chrome_mcp status`
2. If UNHEALTHY, restart: `run_chrome_mcp restart`
3. Verify socat is bound to current LAN IP (not old one)

### socat bound to old IP after network change

```bash
run_chrome_mcp restart   # Automatically rebinds to current LAN IP
```

### Orphaned socat process (PID file lost)

If `run_chrome_mcp stop` can't find the process but port 9223 is still in use:

```bash
# Find the orphan
lsof -i TCP:9223 -sTCP:LISTEN

# Kill it manually
kill <PID>

# Then restart cleanly
run_chrome_mcp start
```

### Ubuntu can't resolve `mymac` hostname

```bash
# On Mac - sync updates Ubuntu's /etc/hosts
dev_sync sync
```

### MCP config has wrong IP in Ubuntu's ~/.claude.json

```bash
# On Mac - dev_sync updates the browserUrl in MCP config
dev_sync sync
```

### VM unreachable after Mac sleep/wake

```bash
# dev_sync handles this automatically with suspend/resume recovery
dev_sync sync

# Or manually via prlctl
prlctl suspend Ubuntu && prlctl resume Ubuntu
```

### macOS firewall blocks ping but HTTP works

This is normal — macOS stealth mode blocks ICMP. Use HTTP to test:
```bash
# From Ubuntu - ping may fail (expected)
ping mymac          # May timeout

# HTTP works fine
curl http://mymac:9223/json/version   # Should succeed
```

## Source Files in Dotfiles Repo

- `util/run_chrome_mcp` — Mac-side Chrome + socat management script
- `util/dev_sync` — Bidirectional IP sync and MCP config management
- `util/requirements/run_chrome_mcp.md` — Original requirements spec
- `setup_ubuntu/chrome_mcp_setup.md` — This document
