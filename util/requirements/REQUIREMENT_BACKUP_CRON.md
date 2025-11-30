# Requirement: Scheduled Backup for backup_cli

## Goal
Add scheduled daily backup (e.g., 18:00) to backup_cli on macOS.

## macOS Sleep Behavior
- Cron jobs do NOT run during sleep
- Missed jobs are NOT re-run on wake

## Options

| Method | Runs During Sleep? | Catch-up Missed? |
|--------|-------------------|------------------|
| `cron` | No | No |
| `launchd` | No | Yes (configurable) |
| `launchd` + `pmset wake` | Yes (wakes Mac) | Yes |

## Recommended: launchd

Use Apple's native `launchd` scheduler:
- Creates plist in `~/Library/LaunchAgents/`
- Can run on next wake if missed scheduled time
- Optional: `sudo pmset repeat wake MTWRFSU 17:55:00` to force wake

## CLI Commands to Add

```bash
backup_cli cron enable [--time 18:00]   # Setup launchd schedule
backup_cli cron disable                  # Remove schedule
backup_cli cron status                   # Show current schedule
```

## Config Addition

```yaml
cron:
  enabled: false
  time: "18:00"
  wake_mac: false  # Optional: use pmset to wake Mac
```
