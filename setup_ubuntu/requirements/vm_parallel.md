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