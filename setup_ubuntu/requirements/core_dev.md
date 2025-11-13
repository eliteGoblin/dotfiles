# Core Development Tools

**Target Environment**: Ubuntu VM (Primary development environment)
**macOS Role**: UI/native apps only, minimal dev tools

## Base System (Ubuntu Only)
- Ubuntu 24.04
- terminator # Multi-tab terminal
- ~/.local/bin in PATH # For user-installed scripts and binaries

## Programming Languages (Ubuntu Only)
- Node.js via NVM # LTS version, project-specific version management
- Python via pyenv # Latest stable, project-specific version management

### JavaScript/TypeScript Development Tools (Ubuntu Only)

**CRITICAL**: Install these tools on Ubuntu only, after setting up NVM.

**Core TypeScript Tools**:
- `typescript` # TypeScript compiler (tsc)
- `tsx` # Fast TypeScript execution (modern, recommended)
- `ts-node` # TypeScript execution (legacy, for compatibility)
- `@types/node` # Node.js type definitions for TypeScript

**Installation**:
```bash
# After NVM is installed and Node.js is active
npm install -g typescript tsx ts-node

# Verify installation
tsc --version      # TypeScript compiler
tsx --version      # tsx runner (modern)
ts-node --version  # ts-node runner (legacy)
```

**Usage**:
```bash
# Compile TypeScript to JavaScript
tsc file.ts           # Produces file.js
tsc --watch          # Watch mode for development
tsc --init           # Initialize tsconfig.json

# Run TypeScript directly (RECOMMENDED - fast, modern)
tsx file.ts          # Execute with tsx (uses esbuild, very fast)
tsx watch file.ts    # Watch mode with auto-restart

# Run TypeScript (legacy compatibility)
ts-node file.ts      # Execute with ts-node (slower, more compatible)
```

**Why tsx over ts-node?**
- ⚡ Much faster (uses esbuild instead of tsc)
- ✅ Better ESM (ES modules) support out of the box
- ✅ Built-in watch mode: `tsx watch file.ts`
- ✅ Simpler configuration for modern TypeScript
- ✅ Actively maintained and modern

**Project-specific Installation (Recommended)**:
```bash
# In project directory
npm install --save-dev typescript tsx @types/node

# Use with npx (no global install needed)
npx tsc --version
npx tsx file.ts
npx tsx watch file.ts
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

## Language Version Managers (Ubuntu Only)
- **pyenv** # Python version management (INSTALL FIRST)
- **nvm** # Node.js version management (INSTALL FIRST)

## Essential Dev Tools (Ubuntu Only)
- git # Version control
- gh # GitHub CLI for PR/issue management
- neovim # Text editor with LSP
- tmux # Terminal multiplexer
- docker # Container runtime (see Docker Installation section below)

## Database Tools (Ubuntu Only)
```bash
# SQLite - Lightweight database
sudo apt install sqlite3 libsqlite3-dev

# PostgreSQL client - psql, pg_dump, pg_restore
sudo apt install postgresql-client

# Verify installation
sqlite3 --version
psql --version
```

## Productivity Tools (Ubuntu Only)
```bash
# Core CLI tools
sudo apt install -y ripgrep fd-find bat tree htop curl jq make build-essential autossh

# Modern CLI tools (via snap for auto-updates)
sudo snap install glow gh

# Git TUI
sudo snap install tig --classic
sudo snap install lazygit

# Eza (modern ls) - from official repo
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install eza

# FZF (fuzzy finder) - install via git for latest version
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

## Additional Recommendations (Ubuntu Only)
- **zoxide** # Smarter cd with frecency algorithm
  ```bash
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
  ```
- **delta** # Better git diff viewer
  ```bash
  # Download from: https://github.com/dandavison/delta/releases
  wget https://github.com/dandavison/delta/releases/download/0.17.0/git-delta_0.17.0_arm64.deb
  sudo dpkg -i git-delta_0.17.0_arm64.deb
  ```

## macOS Setup (Minimal)
**Only for UI and native apps - NOT for development**

```bash
# Only if you occasionally need git on macOS
brew install git

# macOS-specific apps (optional)
# - Rectangle: Window management
# - iTerm2: Better terminal (if not using SSH to Ubuntu)
```

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
**NOT NEEDED** - All development happens on Ubuntu VM

## Mirror Configurations (Ubuntu Only)
- **npm**: `npm config set registry https://registry.npmmirror.com`
- **pip**: Tsinghua University mirror in `~/.pip/pip.conf`

## Installation Order (CRITICAL)
1. **Install pyenv and NVM FIRST** before any language installations
2. **NEVER install Python via apt/brew** - only use pyenv
3. Configure shell integration in dotfiles before language installation
4. Set up mirrors before package installation

## Package Management Strategy (Ubuntu Only)
- **Prefer snap packages** for modern CLI tools (glow, gh, lazygit)
  - Benefits: Auto-updates, sandboxed, consistent across distros
  - Example: `sudo snap install glow gh lazygit`
- **Use apt** for system tools and libraries
  - Databases: `sudo apt install sqlite3 libsqlite3-dev postgresql-client`
  - Core tools: `sudo apt install ripgrep fd-find bat tree htop`
- **Use official repos** for specific tools (eza, delta)
- **Avoid manual binary downloads** unless necessary

## Notes for Claude

### Development Environment Strategy
- **ALL CODING happens on Ubuntu VM** - This is the primary development machine
- **macOS is for UI/native apps ONLY** - Minimal dev tools, no language runtimes
- **Dotfiles are synced** between macOS and Ubuntu, but tools differ by platform

### Ubuntu-Specific Rules
- **NEVER touch system Python** - always use pyenv for Python development
- **NEVER install Python directly** - only via pyenv
- **DOCKER**: ALWAYS check https://docs.docker.com/engine/install/ubuntu/ before installing
- **DOCKER**: NEVER use `docker.io`, snap, or Ubuntu's default packages
- **DOCKER**: MUST use Docker's official APT repository for latest versions
- **DOCKER**: Add user to docker group for non-sudo access
- **DATABASE CLIENTS**: Install via apt (sqlite3, postgresql-client)
- Configure mirrors first for reliable package installation
- Pyenv shell integration is modularized in `.my_zshrc/python/pyenv.sh`
- Verify `python --version` shows pyenv-managed version, not system

### Installation Location
- When installing dev tools → **Ubuntu only**
- When installing UI apps → macOS only
- When in doubt → **Ubuntu (it's the dev machine)**