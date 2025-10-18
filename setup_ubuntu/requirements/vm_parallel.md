# Parallels VM Configuration

## Network Configuration
- Network mode: NAT # Required for proper SSH connectivity
- IP range: 10.211.55.x # Parallels default NAT network

## VM Specifications
- Memory: 8GB
- CPUs: 4 cores
- Storage: Dynamic allocation
- OS: Ubuntu 24.04 ARM64

## SSH Configuration
- SSH server: openssh-server # Auto-installed during setup
- Default shell: ZSH # Set via chsh command
- Terminal: terminator # For GUI sessions

## Essential Settings
```bash
# Configure VM settings via prlctl
prlctl set ubuntu-vm --memsize 8192 --cpus 4
prlctl set ubuntu-vm --device-set net0 --type shared
```

## Notes for Claude
- NAT mode ensures consistent IP assignments
- SSH access configured via host alias `ubuntu`
- Default shell must be ZSH for dotfiles compatibility
- Terminal preference: terminator over default terminal

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
