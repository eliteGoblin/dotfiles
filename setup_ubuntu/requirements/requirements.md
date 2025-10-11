# Development Environment Requirements

## Overview
Ubuntu 24.04 development environment setup for Parallels VM with complete mini-IDE configuration.

## Setup Order
1. **Core Development Tools** - See `core_dev.md`
2. **Shell Environment** - See `shell.md`
3. **Editors & IDE** - See `editors_ide.md`
4. **AI Tools** - See `ai.md`
5. **SSH Configuration** - See `ssh.md`
6. **VM & Backup** - See `vm_parallel.md` and `backup.md`

## Files Structure
```
requirements/
├── requirements.md     # This overview file
├── core_dev.md        # Core dev tools (Node, Python, Git, etc.)
├── shell.md           # ZSH, Oh My Zsh, tmux plugins
├── editors_ide.md     # Neovim mini-IDE with plugins
├── ai.md              # Claude Desktop AI assistant
├── ssh.md             # SSH key management
├── vm_parallel.md     # Parallels VM configuration
└── backup.md          # Backup strategy
```

## 🎯 Expected Final State
After following all requirements, you should have:
- **Modern shell**: ZSH with Oh My Zsh, autosuggestions, autojump
- **Terminal multiplexer**: tmux with mouse support and intuitive keybindings
- **Mini-IDE**: Neovim with file tree, syntax highlighting, git integration
- **AI Assistant**: Claude Desktop for code review and development help
- **Language runtimes**: Node.js via NVM, Python via pyenv
- **Development tools**: Git, Docker, build tools, modern CLI utilities
- **SSH integration**: Seamless host ↔ VM access with key authentication

## 🔄 Integration Flow
1. **Package installation** → Install core tools
2. **Dotfiles installation** → Run `~/.dotfiles/install.sh`
3. **Plugin installation** → Auto-install shell/editor plugins
4. **Verification** → Test all components work together

## Notes for Claude
- **Follow setup order**: Core tools → Shell → Editors → SSH
- **Install then configure**: Install packages first, then run dotfiles installer
- **Auto-install plugins**: Use headless commands for Neovim and tmux plugins
- **Verify each step**: Test functionality before proceeding
- **Cross-platform consistency**: Same dotfiles work on macOS and Ubuntu
- **Plugin commands**:
  - Neovim: `nvim --headless "+Lazy! sync" +qa`
  - tmux: `tmux source ~/.tmux.conf` then `Ctrl+a I` for plugins
- **Test commands**:
  - Shell: `zsh` → should load with Oh My Zsh theme
  - tmux: `tmux` → `Ctrl+a \`` should split vertically
  - Neovim: `nvim .` → should show file tree panel