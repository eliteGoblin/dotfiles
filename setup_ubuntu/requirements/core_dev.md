# Core Development Tools

## Base System
- Ubuntu 24.04
- terminator # Multi-tab terminal
- ~/.local/bin in PATH # For user-installed scripts and binaries

## Programming Languages
- Node.js via NVM # LTS version, project-specific version management
- Python via pyenv # Latest stable, project-specific version management

### JavaScript/TypeScript Development Tools

**CRITICAL**: Install these tools globally via npm after setting up NVM.

**Core TypeScript Tools**:
- `typescript` # TypeScript compiler (tsc)
- `ts-node` # Execute TypeScript files directly without compilation
- `@types/node` # Node.js type definitions for TypeScript

**Installation**:
```bash
# After NVM is installed and Node.js is active
npm install -g typescript ts-node

# Verify installation
tsc --version    # Should show TypeScript version
ts-node --version # Should show ts-node version
```

**Usage**:
```bash
# Compile TypeScript to JavaScript
tsc file.ts           # Produces file.js
tsc --watch          # Watch mode for development

# Run TypeScript directly
ts-node file.ts      # Execute without compiling

# Initialize TypeScript project
tsc --init           # Creates tsconfig.json
```

**Project-specific Installation (Recommended)**:
```bash
# In project directory
npm install --save-dev typescript ts-node @types/node

# Use with npx (no global install needed)
npx tsc --version
npx ts-node file.ts
```

**Benefits**:
- Write type-safe JavaScript with TypeScript
- Catch errors at compile time instead of runtime
- Better IDE support with IntelliSense
- Execute `.ts` files directly with ts-node during development
- Consistent tooling across macOS and Ubuntu

**LSP Support**:
- Neovim uses `ts_ls` language server (installed via Mason)
- Provides autocomplete, error checking, and go-to-definition
- Works independently of global TypeScript installation

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
- gh # GitHub CLI for PR/issue management
- neovim # Text editor with LSP
- tmux # Terminal multiplexer
- docker # Container runtime (see Docker Installation section below)
- sqlite3 # Lightweight database for development and testing

## Productivity Tools
- ripgrep # Fast grep replacement for code search
- fd-find # Fast find replacement with better defaults
- bat # Cat replacement with syntax highlighting
- eza # Ls replacement with git status and colors
- fzf # Fuzzy finder for files and command history
- tree # Directory structure visualization
- tig # Text-mode interface for git repositories
- glow # Render markdown beautifully in terminal (snap on Ubuntu, brew on macOS)
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

## Docker Installation (Ubuntu ONLY)

**CRITICAL**: Ubuntu VMs are used as development machines and MUST install Docker using Docker's official repository, NOT Ubuntu's built-in packages.

### Why Official Docker Repository?
- Ubuntu's `docker.io` and snap packages are outdated
- Missing Docker Compose V2 plugin integration
- Lacks latest features and security patches
- Official repo ensures `docker compose` (not `docker-compose`) works correctly

### Installation Requirements for Claude
Before installing Docker on Ubuntu, Claude MUST:

1. **Check latest official guide**: https://docs.docker.com/engine/install/ubuntu/
2. **Follow that official method** exactly (instructions below may become outdated)

### Official Installation Steps
```bash
# 1. Remove old Docker packages
sudo apt-get remove docker docker-engine docker.io containerd runc podman-docker

# 2. Update package index and install prerequisites
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg

# 3. Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# 4. Set up Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 5. Install Docker Engine, CLI, Buildx, and Compose plugin
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 6. Verify installation
docker --version
docker compose version  # Note: "compose" not "docker-compose"

# 7. Post-installation: Add user to docker group
sudo usermod -aG docker $USER
newgrp docker  # Or logout/login to apply

# 8. Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker

# 9. Test installation
docker run hello-world
```

### Verification Checklist
- [ ] `docker --version` shows latest Docker Engine version
- [ ] `docker compose version` shows Docker Compose V2 (plugin)
- [ ] Docker commands work without `sudo`
- [ ] `docker run hello-world` succeeds

### macOS Docker Installation
- Install Docker Desktop from https://www.docker.com/products/docker-desktop
- Or use Homebrew: `brew install --cask docker`
- Docker Desktop includes Docker Engine, CLI, Compose V2, and Buildx

## Mirror Configurations
- **npm**: `npm config set registry https://registry.npmmirror.com`
- **pip**: Tsinghua University mirror in `~/.pip/pip.conf`

## Installation Order (CRITICAL)
1. **Install pyenv and NVM FIRST** before any language installations
2. **NEVER install Python via apt/brew** - only use pyenv
3. Configure shell integration in dotfiles before language installation
4. Set up mirrors before package installation

## Package Management Strategy
### Ubuntu
- **Prefer snap packages** for modern CLI tools (glow, etc.)
  - Benefits: Auto-updates, sandboxed, consistent across distros
  - Example: `sudo snap install glow gh`
- **Use apt** for system tools and libraries
  - Essential databases: `sudo apt install sqlite3 libsqlite3-dev`
  - GitHub CLI alternative: `sudo apt install gh` (if snap not preferred)
- **Avoid manual binary downloads** unless necessary

### macOS
- **Use Homebrew** for all CLI tools
  - Example: `brew install glow sqlite3 gh`
- Maintain consistency with brew formulae
- SQLite3: Usually pre-installed, update via Homebrew if needed
- GitHub CLI: `brew install gh` for PR/issue management

## Notes for Claude
- **NEVER touch system Python** - always use pyenv for Python development
- **NEVER install Python directly** - only via pyenv
- **DOCKER (Ubuntu)**: ALWAYS check https://docs.docker.com/engine/install/ubuntu/ before installing
- **DOCKER (Ubuntu)**: NEVER use `docker.io`, snap, or Ubuntu's default packages
- **DOCKER (Ubuntu)**: MUST use Docker's official APT repository for latest versions
- **DOCKER**: Add user to docker group for non-sudo access
- Configure mirrors first for reliable package installation
- Pyenv shell integration is modularized in `.my_zshrc/python/pyenv.sh`
- Verify `python --version` shows pyenv-managed version, not system