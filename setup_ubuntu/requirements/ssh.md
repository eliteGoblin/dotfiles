# SSH Access Requirements

## Objective
Enable secure SSH access from macOS host to Ubuntu VM running in Parallels for automated setup and configuration.

## Important Note
SSH keys are managed on macOS host only. The Ubuntu VM does not need its own SSH keys unless accessing external services.

## Authentication Methods
- Primary: SSH public-key authentication # Secure, automated access
- Fallback: Password authentication # For initial setup and recovery
- Key storage: macOS Keychain # Auto-managed, no manual passphrase entry

## SSH Configuration
- Host alias: `ubuntu` # Simple connection via `ssh ubuntu`
- Auto-detect VM IP from Parallels # Handle IP changes automatically
- Agent forwarding enabled # For Git operations inside VM
- Connection persistence # Keepalive settings for stable sessions

## Access Requirements
- Claude can connect using `ssh ubuntu`
- Password prompt when key auth fails
- Sudo access within VM (with password prompt)
- SSH config persists across reboots

## VM Prerequisites
- Ubuntu VM running in Parallels with GUI access
- SSH server installed and running
- User account with sudo privileges
- Network connectivity between host and VM

## Security
- Private key secured in macOS Keychain
- Public key copied to VM authorized_keys
- Password login available as backup
- No plaintext passwords stored

## Notes for Claude
- Ask user for VM password when needed
- Update IP address if VM network changes
- Test connection before proceeding with VM setup tasks