# Core Development Tools

## Base System
- Ubuntu 24.04
- terminator # Multi-tab terminal

## Programming Languages
- Node.js via NVM # LTS version
- Python via pyenv # Latest stable

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

## Notes for Claude
- Install language managers before languages
- Add user to docker group for non-sudo access
- Configure mirrors first for reliable package installation