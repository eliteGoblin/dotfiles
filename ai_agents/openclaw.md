# OpenClaw Installation & Setup

## What is OpenClaw

Open-source, self-hosted AI agent runtime that executes real actions on your machine.
Unlike ChatGPT/Claude chat, it has "hands" — can run terminal commands, automate browsers, manage files, and run scheduled tasks autonomously.

- GitHub: https://github.com/openclaw/openclaw
- Docs: https://docs.openclaw.ai
- Requires its own LLM API key (Anthropic/OpenAI) — Claude Max subscription does NOT apply

## Prerequisites

- Node.js 22+ (required)
- Anthropic API key from https://console.anthropic.com/settings/keys (separate billing from claude.ai)
- Chromium-based browser for browser automation

## Installation (macOS)

```bash
# 1. Ensure Node 22+
nvm install 22
nvm use 22

# 2. Install (use mirror if corp blocks npmjs.org)
npm install -g openclaw@latest --registry https://registry.npmmirror.com

# 3. Verify
openclaw --version

# 4. Configure
openclaw config set gateway.mode local
openclaw config set browser.enabled true
openclaw config set browser.defaultProfile openclaw
openclaw config set browser.headless false
openclaw config set gateway.auth.token "$(openssl rand -hex 32)"

# 5. Set API key
export ANTHROPIC_API_KEY=sk-ant-xxxxx  # add to ~/.creds/personal.sh

# 6. Onboard & install daemon (launchd on macOS)
openclaw onboard --install-daemon

# 7. Verify setup
openclaw doctor
```

## Key Commands

```bash
openclaw gateway --port 18789 --verbose  # Start gateway manually
openclaw agent --message "do something"  # One-shot agent command
openclaw doctor                          # Health check
openclaw update --channel stable         # Update
```

## Browser Automation

```bash
openclaw browser --browser-profile openclaw start   # Launch browser
openclaw browser --browser-profile openclaw status   # Check status
openclaw browser snapshot                            # Get UI tree
openclaw browser screenshot                          # Capture screen
```

## Config Location

- Config: `~/.openclaw/openclaw.json`
- Workspace: `~/.openclaw/workspace`
- Memory: stored as local Markdown files

## Current Status

- Installed: v2026.2.26
- Gateway mode: local
- Browser: enabled (headless=false)
- API key: NOT YET CONFIGURED (need Anthropic API billing)
- Daemon: NOT YET INSTALLED (run `openclaw onboard --install-daemon` after API key)

## vs Claude Code + MCP (current setup)

| Feature | Claude Code + MCP | OpenClaw |
|---------|-------------------|----------|
| Browser automation | Chrome MCP (already working) | Built-in browser tool |
| Terminal execution | Yes | Yes |
| Cost | Covered by Max subscription | Separate API billing |
| Always-on daemon | No (interactive only) | Yes (cron/heartbeat) |
| Messaging channels | No | WhatsApp/Telegram/Slack/etc |
| Persistent memory | Limited | Full local memory |
| Scheduled tasks | No | Yes |

**Verdict**: Skip OpenClaw unless you need always-on daemon, scheduled tasks, or messaging channel control. Claude Code + MCP covers browser/terminal needs at no extra cost.
