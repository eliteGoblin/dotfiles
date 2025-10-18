# Parallels VM Configuration

## Network Configuration
- Network mode: NAT # Required for proper SSH connectivity
- IP range: 10.211.55.x # Parallels default NAT network

## VM Specifications
- Memory: 20GB (optimal for heavy dev + Docker builds)
- CPUs: 8 cores (recommended for parallel builds)
- Storage: Dynamic allocation
- OS: Ubuntu 24.04 ARM64

### Resource Allocation Rationale
**For Mac with 48GB RAM and 14 CPU cores:**
- **20GB RAM allocation** handles:
  - Ubuntu system: ~800MB
  - Development tools (ZSH/tmux/nvim): ~300MB
  - Docker daemon: ~600MB
  - Large Docker builds (5GB+): ~5-6GB
  - Multiple dev servers (node, n8n, etc): ~2-3GB
  - Concurrent Claude AI sessions: ~500MB
  - Headroom for npm/cargo parallel builds: ~7-8GB
  - **Prevents swap usage** under heavy load
- **8 CPU cores** enables:
  - Parallel compilation (make -j8, cargo build)
  - Docker multi-stage builds (concurrent stages)
  - Multiple concurrent docker-compose builds
  - Concurrent dev servers without bottlenecks
  - Leaves 6 cores for macOS

**Why 20GB instead of 16GB:**
- Observed usage: 4GB VM was using 3.3GB + 1.8GB swap (total ~5GB needed minimum)
- Heavy workload: Multiple Claude sessions + Docker builds + dev servers
- Safety margin: Prevents OOM kills during peak usage
- Mac impact: 48GB - 20GB = 28GB free (plenty for macOS)

**Minimum configuration** (not recommended for heavy workloads):
- Memory: 8GB (may cause OOM with large Docker builds)
- CPUs: 4 cores (slower parallel builds)

## SSH Configuration
- SSH server: openssh-server # Auto-installed during setup
- Default shell: ZSH # Set via chsh command
- Terminal: terminator # For GUI sessions

## Essential Settings
```bash
# Configure VM settings via prlctl (VM must be stopped first)
prlctl stop "Ubuntu 24.04.3 ARM64"
prlctl set "Ubuntu 24.04.3 ARM64" --memsize 20480 --cpus 8
prlctl set "Ubuntu 24.04.3 ARM64" --device-set net0 --type shared
prlctl start "Ubuntu 24.04.3 ARM64"
```

**Note**: Memory changes require VM shutdown. CPU changes are safer when VM is stopped.

## Backup Configuration (SmartGuard)
- **Enabled**: Yes (automatic snapshots)
- **Interval**: Weekly (every 7 days)
- **Max snapshots**: 3 (automatic rotation)
- **Location**: `~/Parallels/Ubuntu 24.04.3 ARM64.pvm/Snapshots/`

**Check backup status**:
```bash
prlctl snapshot-list "Ubuntu 24.04.3 ARM64"
ls -lh "~/Parallels/Ubuntu 24.04.3 ARM64.pvm/Snapshots/"
```

## Notes for Claude
- NAT mode ensures consistent IP assignments
- SSH access configured via host alias `ubuntu`
- Default shell must be ZSH for dotfiles compatibility
- Terminal preference: terminator over default terminal
- **Resource allocation**: Always verify Mac's total resources before adjusting VM
- **VM modifications**: Always stop VM before changing memory or CPU allocation

## Port Mapping

### macportmap Utility
**Location**: `~/.local/bin/macportmap` (installed on macOS)

**Purpose**: Easily forward Ubuntu VM ports to macOS localhost with auto-reconnection

**Connection**: Uses SSH host alias `ubuntu` (configured in ~/.ssh/config)

### Usage
```bash
# Map Ubuntu port to macOS (adds 10000 offset)
macportmap 3000      # Ubuntu:3000 → Mac:13000
macportmap 5678      # Ubuntu:5678 → Mac:15678

# List all active port mappings
macportmap list
macportmap status

# Stop specific port forwarding
macportmap stop 3000

# Stop all port forwardings
macportmap stopall

# View logs for specific port
macportmap logs 3000

# Show help
macportmap help
```

### Features
- **Auto-reconnection**: Uses autossh to maintain persistent connections
- **Port offset**: macOS port = Ubuntu port + 10000 (avoids conflicts)
- **Status tracking**: PIDs stored in `~/.local/var/macportmap/`
- **Logging**: Connection logs in `~/.local/var/log/macportmap/`
- **SSH-based**: Uses SSH connection directly (no VM detection required)

### Examples
```bash
# Development workflow
macportmap 3000      # React dev server
macportmap 5173      # Vite dev server
macportmap 8000      # Django/Python server
macportmap list      # Check all mappings

# Access from macOS
curl localhost:13000  # Hits Ubuntu:3000
curl localhost:15173  # Hits Ubuntu:5173
```

### Requirements
- autossh installed on macOS (`brew install autossh`)
- SSH key authentication to Ubuntu VM configured
- SSH host alias `ubuntu` configured in ~/.ssh/config
- Ubuntu VM accessible via `ssh ubuntu`

### Installation
The macportmap script is automatically copied from `util/macportmap` to `~/.local/bin/macportmap` during setup.
