# VM Backup Requirements

## Parallels SmartGuard Requirements
- **Automatic snapshots**: Weekly backups with 3-week retention (3 snapshots total)
- **Initial backup**: Create baseline snapshot after development environment setup
- **Background operation**: Non-disruptive snapshots during VM operation
- **Restore capability**: Point-in-time recovery via Parallels GUI
- **Storage efficiency**: Optimized snapshot storage within +30GB of base VM

## Backup Strategy
- Keep latest 3 SmartGuard snapshots (3 weeks retention)
- Weekly automatic backup schedule (every 7 days)
- Automatic cleanup of expired snapshots (older than 3 weeks)
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
- Retention: Maximum 3 snapshots (current + 2 previous weeks)

## Implementation Notes
- Use Parallels built-in backup functionality
- Schedule via cron or manual trigger
- Verify backup integrity before cleanup
- Location: Dedicated backup directory outside VM folder

## SmartGuard Configuration Update
Current settings show:
- **Interval**: 604800 seconds (7 days) ✅
- **Maximum count**: 2 snapshots ❌ (needs to be 3)

**To update to 3 snapshots**:
1. **Via Parallels Desktop GUI**:
   - Right-click VM → Configure
   - Go to Backup tab
   - Change "Keep" setting from 2 to 3 snapshots

2. **Command line**: `prlctl` doesn't support changing max count via CLI
   - Must use GUI for SmartGuard snapshot count changes

## Notes for Claude
- Always confirm backup success before deleting old ones
- Backup naming should include timestamp for identification
- Consider VM state (suspended vs running) during backup
- **IMPORTANT**: SmartGuard max snapshot count must be changed via GUI, not CLI