# VM Backup Requirements

## Parallels SmartGuard Requirements
- **Automatic snapshots**: Weekly backups with 2-week retention (2 snapshots total)
- **Initial backup**: Create baseline snapshot after development environment setup
- **Background operation**: Non-disruptive snapshots during VM operation
- **Restore capability**: Point-in-time recovery via Parallels GUI
- **Storage efficiency**: Optimized snapshot storage within +20GB of base VM

## Backup Strategy
- Keep latest 2 SmartGuard snapshots (recommended Parallels approach)
- Weekly automatic backup schedule
- Automatic cleanup of expired snapshots
- Efficient incremental snapshots

## Parallels Backup Commands
```bash
# Create backup
prlctl backup ubuntu-vm --storage /path/to/backup/location

# List existing backups
prlctl backup-list ubuntu-vm

# Delete specific backup
prlctl backup-delete ubuntu-vm --id <backup-id>
```

## Automation Requirements
- Trigger: When user says "backup"
- Check: Create backup only if none exists from current week
- Cleanup: Automatically remove backups older than 3 weeks
- Storage: Minimize disk usage through compression

## Implementation Notes
- Use Parallels built-in backup functionality
- Schedule via cron or manual trigger
- Verify backup integrity before cleanup
- Location: Dedicated backup directory outside VM folder

## Notes for Claude
- Always confirm backup success before deleting old ones
- Backup naming should include timestamp for identification
- Consider VM state (suspended vs running) during backup