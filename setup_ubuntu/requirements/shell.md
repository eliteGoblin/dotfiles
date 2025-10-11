# Shell Environment Setup

## ZSH Requirements
- Oh My Zsh framework
- zsh-autosuggestions plugin
- autojump package (for `j` command)

## Dotfiles Integration
- Run dotfiles installer: `~/.dotfiles/install.sh`
- Dotfiles location: `../dotfiles/` (relative to this requirements folder)
- Modular ZSH config loads from `~/.my_zshrc/` via symlink

## Expected Functionality
- Command history suggestions while typing
- Fast directory navigation with `j <directory>`
- No plugin errors on ZSH startup
- Platform-specific configurations loaded automatically

## Platform-Specific Features

### macOS-Only Configuration
- **Word jumping with Option+Arrow keys** (requires iTerm2 setup)
- **Module**: `.my_zshrc/macos/keybindings.sh`
- **Auto-detection**: Only loads on `darwin` systems

### Required iTerm2 Setup (macOS only)
To enable Option+Arrow word jumping:

1. **Open iTerm2 Preferences**: `⌘,`
2. **Navigate to Profiles**: Select your profile → Keys tab
3. **Configure Option Keys** (at bottom of Keys tab):
   - **Left Option Key**: `Esc+`
   - **Right Option Key**: `Esc+`
4. **Result**: Option+← and Option+→ will jump between words

**Note**: Ubuntu terminal doesn't need this configuration as word jumping works differently.

## Tmux Configuration

### 🧭 Overview
Minimal, practical tmux configuration optimized for backend and DevOps workflows inside Ubuntu (running in Parallels or SSH).

### Focus
- Simple, conflict-free keybindings
- Efficient pane management
- Mouse support for resizing and navigation
- Reliable cross-platform behavior (macOS terminal, VS Code, iTerm2)

### ⚙️ Environment Context
| Component | Description |
|-----------|-------------|
| Host | macOS |
| VM OS | Ubuntu 24.04 LTS (CLI or SSH) |
| Terminals | VS Code integrated terminal / macOS Terminal / iTerm2 |
| Connection | Direct Parallels console or SSH |

### 🎯 Functional Goals
- Split and navigate panes with minimal keystrokes
- Enable mouse interactions (scroll, resize, focus panes)
- Avoid macOS / VS Code shortcut conflicts
- Provide session persistence (detach/reattach)
- Include popular plugins for session restore

### 🔑 Key Binding Design
| Function | Key Sequence | Expected Behavior | Notes |
|----------|--------------|-------------------|-------|
| Prefix Key | Ctrl + b | Activates tmux commands | Default preserved (safe globally) |
| Split Vertically | Ctrl + b % | Splits pane left/right | Same as tmux default |
| Split Horizontally | Ctrl + b " | Splits pane top/bottom | Same as tmux default |
| Switch Panes | Alt + ← / → / ↑ / ↓ | Move between panes instantly | Works without prefix |
| Close Pane | Ctrl + d | Closes pane and its shell | Natural exit behavior |
| Detach Session | Ctrl + b d | Detaches tmux session | Used before disconnecting |
| Mouse Scroll | Scroll wheel | Scrolls tmux history buffer | Independent of host scrollback |
| Mouse Click | Click pane | Focus or resize panes | No prefix needed |

### 🧰 Core Configuration Requirements
| Setting | Value | Purpose |
|---------|-------|---------|
| `set -g mouse on` | Enabled | Allow mouse scroll, pane focus, resize |
| `set -g history-limit 10000` | Large buffer | Scroll long logs easily |
| `set -g base-index 1` | 1 | Human-friendly window numbering |
| `setw -g pane-base-index 1` | 1 | Pane numbering starts at 1 |

### Popular Plugins Required
- `tmux-plugins/tpm` # Plugin manager
- `tmux-plugins/tmux-sensible` # Sensible defaults
- `tmux-plugins/tmux-resurrect` # Session restore
- `tmux-plugins/tmux-continuum` # Automatic session save/restore

### Dotfiles Integration
- Configuration file: `tmux/.tmux.conf` (symlinked to `~/.tmux.conf`)
- Plugin manager installed to `~/.tmux/plugins/tpm`
- Cross-platform clipboard integration (pbcopy/xclip)

### Installation Order
1. Install tmux package
2. Install TPM (Tmux Plugin Manager)
3. Run dotfiles installer (creates symlink)
4. Launch tmux and install plugins: `Ctrl+b I`

## Notes for Claude
- Install ZSH plugins before running dotfiles installer
- Install tmux and TPM before dotfiles installation
- Dotfiles installer is idempotent and safe to re-run
- Update dotfiles when adding new tools to sync PATH/aliases