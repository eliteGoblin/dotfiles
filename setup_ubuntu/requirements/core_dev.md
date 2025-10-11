# Core Development Tools

## Base System
- Ubuntu 24.04
- terminator # Multi-tab terminal

## Programming Languages
- Node.js via NVM # LTS version, project-specific version management
- Python via pyenv # Latest stable, project-specific version management

### Python Version Management (pyenv)
**CRITICAL**: Never modify system Python. Use pyenv for all Python development.

**Setup Requirements**:
- Install pyenv on both macOS and Ubuntu
- Configure shell integration for automatic version switching
- Use project-local `.python-version` files for version isolation

**Workflow**:
```bash
# Install specific Python version
pyenv install 3.11.5

# Set global default (fallback)
pyenv global 3.11.5

# Set project-specific version
cd /path/to/project
pyenv local 3.10.12  # Creates .python-version file

# Verify active version
pyenv version

# Create virtual environment with project Python
python -m venv .venv
source .venv/bin/activate
```

**Benefits**:
- Isolates project dependencies from system Python
- Enables multiple Python versions per machine
- Consistent Python versions across macOS and Ubuntu
- Prevents system Python corruption
- Supports legacy project requirements

## Language Version Managers
- **pyenv** # Python version management (INSTALL FIRST)
- **nvm** # Node.js version management (INSTALL FIRST)

## Essential Dev Tools
- git # Version control
- neovim # Text editor with LSP
- tmux # Terminal multiplexer
- docker # Container runtime
- docker-compose # Multi-container orchestration

## Productivity Tools
- ripgrep # Fast grep replacement for code search
- fd-find # Fast find replacement with better defaults
- bat # Cat replacement with syntax highlighting
- eza # Ls replacement with git status and colors
- fzf # Fuzzy finder for files and command history
- tree # Directory structure visualization
- tig # Text-mode interface for git repositories
- htop # Better top with colors and interactivity
- curl # HTTP client for API testing
- jq # JSON processor and pretty printer
- make # Build automation
- build-essential # C/C++ compilation tools
- autossh # Persistent SSH tunnels with auto-reconnect

## Additional Recommendations
- lazygit # TUI for git operations
- zoxide # Smarter cd with frecency algorithm
- delta # Better git diff viewer

## Mirror Configurations
- **npm**: `npm config set registry https://registry.npmmirror.com`
- **pip**: Tsinghua University mirror in `~/.pip/pip.conf`

## Installation Order (CRITICAL)
1. **Install pyenv and NVM FIRST** before any language installations
2. **NEVER install Python via apt/brew** - only use pyenv
3. Configure shell integration in dotfiles before language installation
4. Set up mirrors before package installation

## Notes for Claude
- **NEVER touch system Python** - always use pyenv for Python development
- **NEVER install Python directly** - only via pyenv
- Add user to docker group for non-sudo access
- Configure mirrors first for reliable package installation
- Pyenv shell integration is modularized in `.my_zshrc/python/pyenv.sh`
- Verify `python --version` shows pyenv-managed version, not system