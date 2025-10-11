# 🧰 macOS + Ubuntu 24.04 Dev Environment Bootstrap (Claude-Aware)

This repo defines a **complete, self-rebuilding development environment**
spanning both the **macOS host** and the **Ubuntu 24.04 VM (Parallels guest)**.

Claude or an equivalent automation agent should read this document first.

---

## 1️⃣ High-Level Overview

| Layer | Purpose | Owner |
|--------|----------|--------|
| macOS Host | Install Parallels, create VM, configure SSH | Claude |
| Ubuntu 24.04 VM | Install core dev stack + dotfiles | Claude |
| Dotfiles Repo | Persist Zsh + tool configs | `eliteGoblin/dotfiles` |
| Automation | Declarative YAML manifests under `requirements/` | You + Claude |

---

## 2️⃣ macOS-Side Setup (Host Layer)

### 🔐 SSH & Keychain

```bash
# Generate key if needed
ssh-keygen -t ed25519 -C "frank@macbook"

# Add to Keychain for persistence
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

### SSH configuration (~/.ssh/config)

```bash
Host ubuntu
  HostName 10.211.55.3
  User parallels
  IdentityFile ~/.ssh/id_ed25519
  UseKeychain yes
  AddKeysToAgent yes
```

Claude should confirm SSH connectivity via:

```bash
ssh ubuntu "echo Connected"
```

### 💻 Parallels VM Provisioning (macOS)

Claude may manage Parallels via CLI:

```bash
# Install Parallels Desktop if missing
brew install --cask parallels || true

# Create Ubuntu 24.04 VM
prlctl create ubuntu-vm --distribution ubuntu --dst ~/Parallels
prlctl start ubuntu-vm
```

Once the VM boots:

```bash
prlctl set ubuntu-vm --memsize 8192 --cpus 4 --device-bootorder "hdd0 cdrom0"
```

Claude should:
1. Wait for SSH to become available
2. Use credentials (frank / SSH key)
3. Proceed with Ubuntu setup below

⚠️ If Parallels automation isn't available via CLI, Claude should output the exact `prlctl` commands and wait for user confirmation.

---

## 3️⃣ Ubuntu 24.04 Core Environment (Guest Layer)

After SSHing into `ubuntu`, Claude must:

1. Apply `requirements/core_dev.md`
2. Apply `requirements/shell.md`
3. Apply `requirements/editors_ide.md`
4. Install dotfiles from `../dotfiles/`
5. Sync PATH + plugin configs
6. Verify core commands

### Verification checklist:

```bash
zsh --version
node -v
python3 --version
terraform version
docker ps
nvim --version
```

---

## 4️⃣ Requirements Folder Layout

```
requirements/
│
├── requirements.md        # Overview and setup order
├── core_dev.md           # Core Linux + Node/Python tools
├── shell.md              # ZSH, Oh My Zsh, plugins
├── editors_ide.md        # Neovim, LSP servers
└── ssh.md                # SSH access configuration
```

---

## 5️⃣ Dotfiles Integration

Claude rules:

1. Clone `https://github.com/eliteGoblin/dotfiles`
2. Run its `install.sh`
3. When new tools (Node, Python, Terraform) are installed, update related modular files in `.my_zshrc/` and commit back
4. Never overwrite existing configs; patch safely
5. Commit message format: `"chore: auto-update PATH or plugin configs for <tool>"`

---

## 6️⃣ Core Development Stack (Summary)

| Category | Tools |
|----------|-------|
| Terminal & Shell | Terminator, Zsh (Oh My Zsh, Powerlevel10k) |
| Languages | Node.js (NVM), Python (Pyenv) |
| Dev Tools | Git, Docker, Terraform, Neovim |
| DevOps | AWS CLI, Azure CLI, Helm, Kubectl |
| Security | Snyk, Trivy, Checkov |
| Observability | Prometheus, Grafana (via Docker) |

---

## 7️⃣ Agent Behavior Rules

Claude should:

1. Read requirements files before installation
2. Apply them idempotently (safe re-run)
3. Integrate with dotfiles repo for config updates
4. Log or output changes for auditability
5. Never modify `~/.ssh/config` or macOS Keychain automatically — these are user-managed
6. Maintain work notes in `claude_worknotes/` for each requirement

---

## 8️⃣ Running It All (Manual)

If you want to bootstrap manually instead of Claude:

```bash
ssh ubuntu
git clone https://github.com/eliteGoblin/dotfiles ~/.dotfiles
cd ~/.dotfiles && ./install.sh
```

Then apply requirement setups manually or via Claude.