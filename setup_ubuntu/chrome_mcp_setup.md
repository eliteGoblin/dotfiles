# Chrome MCP — Cross-Environment Setup

## TL;DR

Goal: one persistent Chrome browser, one set of logged-in sessions, driven by
[chrome-devtools-mcp](https://github.com/ChromeDevTools/chrome-devtools-mcp)
from Claude Code. No matter the host OS, the rule is the same:

1. **One dedicated Chrome profile** (`chrome-mcp-profile`) — log in once, reuse forever.
2. **Bind the debug port to localhost only** — never expose to LAN.
3. **A small lifecycle script** that starts Chrome on demand and reuses it if already running.
4. **A user-scope MCP entry** in `~/.claude.json` so it works from any project folder.

Pick your environment:

- [Mac (native)](#mac-native) — Claude Code on macOS, Chrome on the same Mac.
- [Mac + Parallels Ubuntu VM](#mac--parallels-ubuntu-vm) — Claude in the VM, Chrome on the Mac, exposed via socat over the bridge network.
- [Windows + WSL](#windows--wsl) — Claude in WSL, Chrome on Windows, reached via WSL ↔ Windows host networking.

The [Common pattern](#common-pattern) section spells out the contract every
environment satisfies; the Daily workflow / Troubleshooting / File map at the
bottom apply to all of them.

---

## Common pattern

```
┌────────────────────────────────┐                ┌────────────────────────────────┐
│ Claude Code host (any)         │                │ Chrome host (any)              │
│                                │                │                                │
│  Claude reads ~/.claude.json   │                │  Chrome (one dedicated profile)│
│  user-scope mcpServers:        │                │  --user-data-dir=…/chrome-mcp- │
│                                │ ── connects ─► │     profile                    │
│  "chrome-devtools": stdio →    │   browserUrl   │  --remote-debugging-port=9222  │
│    run_chrome_mcp_<env> mcp    │                │  --remote-debugging-address=   │
│                                │                │     127.0.0.1                  │
│  helper:                       │                │                                │
│    1. probe browserUrl         │                │  Bound to loopback only.       │
│    2. start Chrome if down     │                │  Never on LAN.                 │
│    3. exec npx chrome-devtools-│                │                                │
│       mcp --browserUrl=…       │                │                                │
└────────────────────────────────┘                └────────────────────────────────┘
```

What changes between environments:

| Concern              | Mac native              | Mac + Parallels VM            | Windows + WSL                          |
|----------------------|-------------------------|-------------------------------|----------------------------------------|
| Chrome host          | macOS                   | macOS                         | Windows                                |
| Claude host          | macOS                   | Ubuntu VM                     | WSL2                                   |
| Reachability         | localhost               | LAN bridge via `socat` proxy  | wsl-vpnkit / mirrored localhost        |
| Lifecycle script     | `run_chrome_mcp` (bash) | `run_chrome_mcp` + `dev_sync` | `run_chrome_mcp_wsl` + `run_chrome_mcp.ps1` |
| MCP `browserUrl`     | `http://127.0.0.1:9222` | `http://<MAC_IP>:9223`        | autodetected (e.g. `http://192.168.127.254:9222`) |

All three approaches share the same Chrome flag set:

```text
--user-data-dir=<dedicated-profile-dir>
--remote-debugging-port=9222
--remote-debugging-address=127.0.0.1
--remote-allow-origins=*
--no-first-run
--no-default-browser-check
```

`--remote-allow-origins=*` is required for chrome-devtools-mcp to attach via
WebSocket on Chrome 111+. The port is bound to loopback only, so the surface is
limited to local processes.

---

## Mac (native)

Claude on macOS, Chrome on the same Mac — the simplest case.

### One-time setup

```bash
# 1. Install the lifecycle script (bash)
cp util/run_chrome_mcp ~/.local/bin/run_chrome_mcp
chmod +x ~/.local/bin/run_chrome_mcp

# 2. Start Chrome with the dedicated profile
run_chrome_mcp start

# 3. Register the MCP server at user scope
claude mcp add -s user chrome-devtools -- \
  npx -y chrome-devtools-mcp@latest --browserUrl=http://127.0.0.1:9222

# 4. Verify
curl http://127.0.0.1:9222/json/version
claude mcp list      # chrome-devtools should be ✓ Connected
```

### Daily

`run_chrome_mcp start` on first use of the day; Chrome stays running until you
explicitly stop it. Re-running `start` on an already-running Chrome is a no-op.

### Notes

- `run_chrome_mcp` here is the macOS-only variant in `util/run_chrome_mcp`. It
  manages a Chrome process bound to `127.0.0.1:9222`.
- For this case there is no socat / no IP-sync; everything is local.
- The dedicated profile lives at `~/.chrome-mcp-profile`. Log in once.

---

## Mac + Parallels Ubuntu VM

Claude runs in the Ubuntu VM, Chrome runs on the macOS host. The VM reaches
Chrome over Parallels' bridge network via a local socat proxy on the Mac.

> This is the original setup in this repo and remains the canonical reference
> for the VM topology. The full architecture diagram, requirements, and daily
> workflow live below.

### Architecture

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

### Prerequisites

- macOS with Parallels Desktop and an Ubuntu VM
- Both machines on the same bridge network (Parallels handles this)
- SSH access from Mac to Ubuntu VM configured

### Step 1: Mac — Install dependencies

```bash
brew install socat        # for proxying Chrome DevTools to LAN
# Google Chrome from https://www.google.com/chrome/
```

### Step 2: Mac — Install run_chrome_mcp

```bash
cp util/run_chrome_mcp ~/.local/bin/run_chrome_mcp
chmod +x ~/.local/bin/run_chrome_mcp
run_chrome_mcp help
```

The script manages:
- Chrome with `--remote-debugging-port=9222` using `~/.chrome-mcp-profile`
- socat proxy binding `LAN_IP:9223` → `127.0.0.1:9222`
- PID/health tracking under `~/.chrome-mcp/`

```bash
run_chrome_mcp start     # Start Chrome + socat
run_chrome_mcp stop      # Stop both
run_chrome_mcp status    # Health check
run_chrome_mcp restart   # Use after a network change
```

### Step 3: Mac — Install dev_sync

```bash
cp util/dev_sync ~/.local/bin/dev_sync
chmod +x ~/.local/bin/dev_sync
```

Edit the config block at the top of `dev_sync` to match your environment:

```bash
VM_NAME="Ubuntu"           # Parallels VM name
VM_USER="parallels"        # Ubuntu username
MAC_HOSTNAME="mymac"       # Hostname for Mac in Ubuntu's /etc/hosts
UBUNTU_HOSTNAME="myubuntu" # Hostname for Ubuntu in Mac's /etc/hosts
SSH_CONFIG_HOST="ubuntu"   # SSH config host alias
```

```bash
# In ~/.creds/local.sh (sourced by dev_sync)
export UBUNTU_SUDO_PASSWORD="your-ubuntu-password"
```

### Step 4: Ubuntu VM — Install Node

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ~/.bashrc
nvm install 22 && nvm use 22
```

### Step 5: Ubuntu VM — Optional npx wrapper for blocked registries

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

Skip if your network doesn't block npm.

### Step 6: Ubuntu VM — MCP server entry

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

`dev_sync sync` keeps `<MAC_IP>` current.

### Step 7: Bring it up

```bash
# On Mac
run_chrome_mcp start
dev_sync sync

# Verify
run_chrome_mcp status
dev_sync status
```

### Step 8: Smoke test from Ubuntu

```bash
curl http://<MAC_IP>:9223/json/version    # Should return Chrome version JSON
claude                                     # auto-connects to Chrome MCP
```

### Daily workflow

```bash
# After Mac sleep/wake or network change
run_chrome_mcp restart   # Rebind socat to new LAN IP
dev_sync sync            # Sync IPs, update Ubuntu MCP config, verify
```

`dev_sync sync` handles VM unreachable after Mac sleep automatically with a
suspend/resume of the VM.

### What dev_sync does

1. Detects Mac LAN IP and Ubuntu VM IP (via `prlctl`)
2. Updates Mac's `~/.ssh/config` (HostName for `ubuntu`)
3. Updates Mac's `/etc/hosts` (`myubuntu` → Ubuntu IP)
4. Updates Ubuntu's `/etc/hosts` (`mymac` → Mac IP) over SSH
5. Updates Ubuntu's `~/.claude.json` MCP `browserUrl` with Mac's current IP
6. Verifies Chrome MCP reachable from Ubuntu
7. Auto-recovers unreachable VM via Parallels suspend/resume

### File map (Mac+VM)

| File | Side | Purpose |
|------|------|---------|
| `~/.local/bin/run_chrome_mcp`  | Mac    | Chrome + socat lifecycle |
| `~/.local/bin/dev_sync`        | Mac    | IP sync, MCP config update, VM recovery |
| `~/.chrome-mcp/`               | Mac    | State (PIDs, logs) |
| `~/.chrome-mcp-profile/`       | Mac    | Dedicated Chrome profile |
| `~/.ssh/config`                | Mac    | SSH alias for Ubuntu (auto-updated) |
| `/etc/hosts` (`myubuntu`)      | Mac    | Ubuntu IP (auto-updated) |
| `~/.creds/local.sh`            | Mac    | `UBUNTU_SUDO_PASSWORD` |
| `~/.claude.json`               | Ubuntu | MCP servers (auto-updated by dev_sync) |
| `~/.local/bin/npx-mcp`         | Ubuntu | npx wrapper (optional) |
| `/etc/hosts` (`mymac`)         | Ubuntu | Mac IP (auto-updated by dev_sync) |

---

## Windows + WSL

Claude runs in WSL2, Chrome runs on Windows. WSL ↔ Windows networking is
handled by the WSL kernel (mirrored mode / localhostForwarding) or by
`wsl-vpnkit` for corp/Cisco AnyConnect setups; the helper auto-detects which IP
from inside WSL reaches Windows host's loopback.

### What you get

- One Chrome instance on Windows with a dedicated profile at
  `%USERPROFILE%\chrome-mcp-profile`. Log in once, sessions persist.
- A WSL bash helper at `~/.local/bin/run_chrome_mcp_wsl` that:
  - probes Windows-reachability across `127.0.0.1`, `192.168.127.254` (wsl-vpnkit),
    and the default-route gateway
  - starts Chrome on Windows via `powershell.exe` if it's not already up
  - in `mcp` mode, execs `npx chrome-devtools-mcp@latest` for Claude
- A user-scope MCP entry in `~/.claude.json` so it works from any project folder.

### Prerequisites

- Windows 10 or 11 with WSL2 (any modern distro).
- Google Chrome installed on Windows (default location works).
- Node.js in WSL (any LTS via nvm is fine; the helper finds it).
- For corp/Cisco AnyConnect users: `wsl-vpnkit` running. Start it with:
  ```powershell
  wsl.exe -d wsl-vpnkit --cd /app wsl-vpnkit
  ```
  (Without it, WSL networking will be flaky on Cisco AnyConnect.)

### Setup (one-time)

```bash
# 1. Symlink the WSL helper into ~/.local/bin (or copy if you prefer)
ln -sfn ~/devel/dotfiles/util/run_chrome_mcp_wsl ~/.local/bin/run_chrome_mcp_wsl
# (the helper finds util/run_chrome_mcp.ps1 automatically via $DOTFILES or relative path)

# 2. Sanity-check connectivity to Windows
~/.local/bin/run_chrome_mcp_wsl doctor

# 3. Start Windows Chrome (creates the profile dir on first run)
~/.local/bin/run_chrome_mcp_wsl start
# A Chrome window opens on Windows with a fresh profile.
# Log in to whatever sites you need — those sessions persist.

# 4. Register at user scope so it's global across all projects
claude mcp add -s user chrome-devtools -- ~/.local/bin/run_chrome_mcp_wsl mcp

# 5. Verify
curl "$(~/.local/bin/run_chrome_mcp_wsl url)/json/version"
claude mcp list                            # ✓ Connected
cd /tmp && claude mcp list                 # works from anywhere
```

### Daily flow

Nothing. The helper is idempotent:

- If Chrome is already up, `claude mcp list` is instant.
- If Chrome isn't up, the helper starts it on first MCP call (~5–15s).
- Sessions persist across Chrome restarts (dedicated profile).

If you reboot Windows: next Claude invocation auto-starts Chrome.

If you reboot WSL: nothing to do.

If `wsl-vpnkit` dies: restart it (`wsl.exe -d wsl-vpnkit --cd /app wsl-vpnkit`).

### Helper commands

```bash
run_chrome_mcp_wsl mcp        # default; what Claude calls
run_chrome_mcp_wsl start      # ensure Chrome is up; print URL
run_chrome_mcp_wsl stop       # stop the dedicated Chrome on Windows
run_chrome_mcp_wsl status     # quick health check
run_chrome_mcp_wsl url        # print resolved browserUrl
run_chrome_mcp_wsl restart    # stop then start
run_chrome_mcp_wsl doctor     # diagnose WSL ↔ Windows connectivity
```

### Env overrides

| Var               | Purpose                                                  |
|-------------------|----------------------------------------------------------|
| `CHROME_MCP_PORT` | Debug port (default 9222)                                |
| `CHROME_MCP_HOST` | Pin a specific Windows-side IP and skip auto-detection.  |
| `RUN_CHROME_MCP_PS1` | Override path to the PowerShell helper.               |
| `NPX_BIN`         | Override npx path used by `mcp` mode.                    |

### How auto-detect works

`run_chrome_mcp_wsl` probes these candidates in order:

1. `127.0.0.1` — works with WSL2 mirrored networking and `localhostForwarding=true`.
2. `192.168.127.254` — wsl-vpnkit / gvisor-tap-vsock host-services IP.
3. The default-route gateway from `ip route show default`.

The first one that returns HTTP 200 from `/json/version` becomes the
`browserUrl`. The `doctor` subcommand prints the full table.

### File map (Windows+WSL)

| File | Side | Purpose |
|------|------|---------|
| `util/run_chrome_mcp_wsl`              | WSL repo | Source of the bash helper |
| `~/.local/bin/run_chrome_mcp_wsl`      | WSL      | Symlink to the above |
| `util/run_chrome_mcp.ps1`              | WSL repo | PowerShell helper (Chrome lifecycle on Windows) |
| `%USERPROFILE%\chrome-mcp-profile\`    | Windows  | Dedicated Chrome profile (log in once) |
| `~/.claude.json` `mcpServers`          | WSL      | User-scope MCP entry (added by `claude mcp add -s user`) |

### Security notes

- Chrome's debug port is bound to **`127.0.0.1` on Windows** — never to a LAN
  interface. The reachability path from WSL is via the WSL ↔ Windows kernel
  bridge (mirrored / localhostForwarding) or the wsl-vpnkit userspace proxy,
  not a real network exposure.
- `--remote-allow-origins=*` is needed by chrome-devtools-mcp; combined with
  loopback-only binding, the practical exposure is local processes only.

### Troubleshooting

#### `doctor` shows Windows IS listening but no WSL candidate gets 200

Almost certainly `wsl-vpnkit` isn't running (or your WSL networking config
changed).

```powershell
# In any Windows shell
wsl.exe -d wsl-vpnkit --cd /app wsl-vpnkit
```

Then re-run `~/.local/bin/run_chrome_mcp_wsl doctor`.

#### Helper started Chrome but no candidate IP reaches it

The detection list only contains the common candidates. If your setup uses a
different IP, find it manually and pin it:

```bash
# From WSL, find an IP that returns 200
for ip in $(grep -E '^[0-9.]+' /etc/resolv.conf | awk '{print $2}') 192.168.127.254 127.0.0.1; do
  curl -fsS --max-time 2 "http://$ip:9222/json/version" >/dev/null && echo "OK: $ip"
done

# Pin it for future runs
echo "export CHROME_MCP_HOST=192.168.127.254" >> ~/.bashrc
```

#### Claude says MCP server failed to start

Run the helper manually to see real stderr:

```bash
~/.local/bin/run_chrome_mcp_wsl mcp
```

Common issues:
- `npx not found` — install Node.js (e.g. via nvm) so the helper's `resolve_npx`
  finds a binary.
- `powershell.exe not found` — you're not in WSL; this helper is WSL-only.

#### "Chrome is already running" on the dedicated profile but the port isn't open

```bash
~/.local/bin/run_chrome_mcp_wsl restart
```

This stops the dedicated Chrome (matched by its `--user-data-dir`) and starts
a fresh one with the debug port. Your normal Chrome (different profile) is not
affected.

---

## Source files in this repo

| Path                                      | Used by                            |
|-------------------------------------------|------------------------------------|
| `util/run_chrome_mcp`                     | Mac native, Mac + Parallels VM     |
| `util/dev_sync`                           | Mac + Parallels VM                 |
| `util/run_chrome_mcp_wsl`                 | Windows + WSL (bash helper)        |
| `util/run_chrome_mcp.ps1`                 | Windows + WSL (PowerShell helper)  |
| `util/requirements/run_chrome_mcp.md`     | Mac+VM original requirements spec  |
| `setup_ubuntu/chrome_mcp_setup.md`        | This document                      |

---

## Tracking — environment coverage matrix

| Environment | Status | Notes |
|-------------|--------|-------|
| Mac + Parallels Ubuntu VM | ✅ Done | `util/run_chrome_mcp` + `util/dev_sync`. Mac socat exposes `<MAC_IP>:9223`; Ubuntu connects. |
| Windows + WSL | ✅ Done | `util/run_chrome_mcp_wsl` + `util/run_chrome_mcp.ps1`. Auto-detects WSL→Windows host IP (`127.0.0.1` mirrored / `192.168.127.254` wsl-vpnkit). User-scope MCP entry. |
| Mac native | 🟡 Pending | Practically: drop the socat hop and point `browserUrl` at `http://127.0.0.1:9222`. Section above is a stub; verify the `run_chrome_mcp` script works without the socat step and add a one-line `claude mcp add -s user`. |
| Mac + Ubuntu VM (non-Parallels: UTM/VirtualBox/libvirt) | 🟡 Pending | Same pattern, but `dev_sync`'s `prlctl` calls need to become a pluggable VM driver. |
| Linux native | 🟡 Pending | Equivalent to Mac native; just adapt path and chrome.exe → `google-chrome`. |

### Shared invariants (apply to every environment)

- One dedicated Chrome profile (`chrome-mcp-profile`) per environment — log in once.
- Debug port bound to `127.0.0.1` on the Chrome host (never LAN). Cross-host
  reach is via socat-on-loopback (Mac+VM) or kernel/userspace bridge (WSL).
- `--remote-allow-origins=*` (required by chrome-devtools-mcp on Chrome 111+).
- MCP entry registered at user scope (`claude mcp add -s user`) so it works
  from any project folder.
- The lifecycle helper is idempotent: probe first, only start Chrome if down.

### Open follow-ups

- [ ] Mac native: verify `util/run_chrome_mcp` works without socat path (or add a `--local` mode), update Mac native section, add `claude mcp add -s user` snippet.
- [ ] Mac + Ubuntu VM (non-Parallels): generalize `dev_sync` to use a pluggable VM driver (`utmctl`, `VBoxManage`, `virsh`) instead of hardcoded `prlctl`.
- [ ] Optional: WSL helper could cache the resolved host between invocations under `~/.cache/run_chrome_mcp_wsl/host` to skip detection on warm starts (saves ~50ms per MCP spawn).
