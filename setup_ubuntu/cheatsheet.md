# Ubuntu Development Environment Cheatsheet

Quick reference for the 80% most used commands in your development setup.

## 🚀 Tmux - Terminal Multiplexer

### Essential Commands
```bash
# Session Management
tmux                    # Start new session
tmux new -s mysession   # Start named session
tmux ls                 # List sessions
tmux attach -t mysession # Attach to session
tmux kill-session -t mysession # Kill session

# Inside tmux (prefix = Ctrl+a)
Ctrl+a d               # Detach from session
Ctrl+a `               # Split pane vertically (left/right)
Ctrl+a -               # Split pane horizontally (top/bottom)
Ctrl+a c               # Create new window
Ctrl+a n               # Next window
Ctrl+a p               # Previous window
Ctrl+a ,               # Rename window
Ctrl+a &               # Kill window
Ctrl+a x               # Kill pane

# Pane Navigation (NO PREFIX NEEDED - configured in your dotfiles)
Alt + ← / → / ↑ / ↓    # Switch between panes instantly
Ctrl+d                 # Close current pane

# Plugin Management (TPM)
Ctrl+a I               # Install plugins
Ctrl+a U               # Update plugins
Ctrl+a Alt+u           # Uninstall plugins

# Session Persistence (tmux-resurrect)
Ctrl+a Ctrl+s          # Save session
Ctrl+a Ctrl+r          # Restore session
```

### Quick Reference Table
| Action | Key | Description |
|--------|-----|-------------|
| Split vertically | `Ctrl+a` → `` ` `` | Left-right panes |
| Split horizontally | `Ctrl+a` → `-` | Top-bottom panes |
| Move pane focus | `Alt + ←/→/↑/↓` | Navigate between panes |
| Close pane | `Ctrl+d` | Exit shell |
| New window | `Ctrl+a` → `c` | Like a new tab |
| Switch window | `Ctrl+a` → `n/p` | Next / previous |
| Rename window | `Ctrl+a` → `,` | Helpful for clarity |
| Kill window | `Ctrl+a` → `&` | Close it |
| Detach session | `Ctrl+a` → `d` | Leave tmux running |

### Mouse Support (Enabled)
- **Click pane** to focus it
- **Scroll wheel** to scroll through history
- **Drag pane borders** to resize
- **Double-click** to select word, **triple-click** for line

## 📝 Neovim - Enhanced IDE

### Getting Started
```bash
nvim filename          # Open file
nvim .                 # Open current directory (auto-opens file tree)
```

### File Management (nvim-tree plugin)
| Key | Action |
|-----|--------|
| `Ctrl+n` | Toggle file tree |
| `Space+e` | Find current file in tree |
| `a` | Create file |
| `A` | Create directory |
| `d` | Delete file/directory |
| `r` | Rename file/directory |
| `x` | Cut file |
| `c` | Copy file |
| `p` | Paste file |

### Fuzzy Finding (Telescope)
| Key | Action |
|-----|--------|
| `Space+ff` | Find files |
| `Space+fa` | Find all files (including hidden like .zshrc) |
| `Space+fg` | Live grep search |
| `Space+fb` | Browse buffers |
| `Space+fh` | Help tags |

### Code Navigation (LSP)
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Show hover documentation |
| `Space+ca` | Code actions |

### Completion & Snippets
| Key | Action |
|-----|--------|
| `Tab` | Next completion item |
| `Shift+Tab` | Previous completion item |
| `Enter` | Confirm completion |

### Comments
| Key | Action |
|-----|--------|
| `gc` | Toggle line comment |
| `gb` | Toggle block comment |
| `gcc` | Comment current line |

### Terminal (VSCode-like)
| Key | Action |
|-----|--------|
| `Ctrl+t` | Toggle terminal (SSH-friendly) |
| `Ctrl+`` ` | Toggle terminal (local only) |
| `Space+t` | Toggle terminal (alternative) |
| `Esc` | Exit terminal mode |
| `Ctrl+h/j/k/l` | Navigate between windows (from terminal) |

### Basic Navigation
```
h j k l               # Left, Down, Up, Right
w / b                 # Next/previous word
0 / $                 # Beginning/end of line
gg / G                # Top/bottom of file
Ctrl+d / Ctrl+u       # Page down/up
```

### Essential Editing
```
i                     # Insert mode (before cursor)
a                     # Insert mode (after cursor)
o                     # New line below and insert
O                     # New line above and insert
Esc                   # Exit insert mode

dd                    # Delete line
yy                    # Copy line
p                     # Paste
u                     # Undo
Ctrl+r                # Redo

/search_term          # Search forward
n / N                 # Next/previous search result
:%s/old/new/g         # Replace all occurrences
```

### File Operations
```
:w                    # Save file
:q                    # Quit
:wq                   # Save and quit
:q!                   # Quit without saving
:e filename           # Open file
:sp filename          # Split horizontal and open file
:vsp filename         # Split vertical and open file
```

### Window/Split Management
```
Ctrl+w h/j/k/l        # Navigate between splits
Ctrl+w +/-            # Resize splits
Ctrl+w =              # Equal split sizes
Ctrl+w q              # Close current split
```

### Quick IDE Features
```
:term                 # Open terminal in split
Ctrl+z                # Suspend nvim (return with 'fg')
:!command             # Run shell command
:set number           # Show line numbers
:set relativenumber   # Show relative line numbers
```

## 🐚 ZSH & Shell Navigation

### Directory Navigation
```bash
cd /path/to/dir       # Change directory
cd -                  # Go back to previous directory
pwd                   # Show current directory
ls -la                # List all files with details
tree                  # Show directory structure

# Autojump (j command)
j projects            # Jump to directory containing "projects"
j -s                  # Show autojump statistics
```

### File Operations
```bash
mkdir dirname         # Create directory
touch filename        # Create empty file
cp source dest        # Copy file
mv source dest        # Move/rename file
rm filename           # Delete file
rm -rf dirname        # Delete directory and contents

# Advanced file tools (installed)
rg "search term"      # Ripgrep - fast text search
fd filename           # Find files
bat filename          # Better cat with syntax highlighting
eza                   # Better ls with colors
```

### Git Commands
```bash
git status            # Check repository status
git add .             # Stage all changes
git commit -m "msg"   # Commit with message
git push              # Push to remote
git pull              # Pull from remote
git log --oneline     # View commit history
git diff              # View changes
```

### System Monitoring
```bash
htop                  # Interactive process viewer
df -h                 # Disk space usage
free -h               # Memory usage
ps aux | grep name    # Find running processes
kill -9 PID           # Kill process by ID
```

## 🔗 SSH & Remote Work

### SSH to Ubuntu VM
```bash
ssh ubuntu            # Connect to Ubuntu VM (configured)
scp file ubuntu:~/    # Copy file to VM
scp ubuntu:~/file .   # Copy file from VM
```

### macportmap Utility (Recommended)
```bash
# Quick port forwarding with auto-reconnection
macportmap 3000         # Ubuntu:3000 → Mac:13000
macportmap 5173         # Ubuntu:5173 → Mac:15173
macportmap 8000         # Ubuntu:8000 → Mac:18000

# Management commands
macportmap list         # Show all active mappings
macportmap stop 3000    # Stop specific forwarding
macportmap stopall      # Stop all forwardings
macportmap logs 3000    # View connection logs

# Access in macOS browser (port + 10000)
open http://localhost:13000  # For Ubuntu:3000
open http://localhost:15173  # For Ubuntu:5173
```

### Manual Port Forwarding (Alternative)
```bash
# Forward VM development servers to macOS
autossh -M 20000 -L 3000:localhost:3000 ubuntu  # React/Next.js
autossh -M 20001 -L 8080:localhost:8080 ubuntu  # General web
autossh -M 20002 -L 5000:localhost:5000 ubuntu  # Flask/Express

# Background persistent forwarding
autossh -M 20000 -f -N -L 3000:localhost:3000 ubuntu
```

### Development Workflow
```bash
# 1. Start dev server in VM
ssh ubuntu
cd project && npm run dev  # Runs on port 3000

# 2. Forward port (in macOS terminal)
macportmap 3000          # Much simpler!

# 3. Access in macOS browser
open http://localhost:13000  # Note: port 3000 + 10000 = 13000
```

### SSH Session Management
```bash
ssh-add -l            # List SSH keys
ssh-add ~/.ssh/key    # Add SSH key
```

## 🐳 Docker Commands

### Container Management
```bash
docker ps             # List running containers
docker ps -a          # List all containers
docker images         # List images
docker run -it image  # Run container interactively
docker exec -it container bash # Access running container
docker stop container # Stop container
docker rm container   # Remove container
```

### Quick Development
```bash
docker run -it --rm ubuntu:22.04 bash  # Quick Ubuntu container
docker run -it --rm -v $(pwd):/app node:18  # Node.js with current dir
```

## 🌐 Development Tools

### Node.js (via NVM)
```bash
nvm ls                # List installed versions
nvm use 18            # Use Node.js v18
nvm install --lts     # Install latest LTS
npm install           # Install dependencies
npm start             # Start application
```

### Python (via pyenv)
```bash
pyenv versions        # List installed versions
pyenv global 3.12     # Set global Python version
pyenv local 3.11      # Set local Python version
pip install package   # Install package
```

## 🔧 Quick Troubleshooting

### Performance
```bash
top                   # CPU usage
iotop                 # I/O usage (if installed)
netstat -tulpn        # Network connections
```

### Logs
```bash
tail -f /var/log/syslog        # System logs
journalctl -f                  # Systemd logs
docker logs container_name     # Docker container logs
```

### Network
```bash
ping google.com       # Test connectivity
curl -I url           # HTTP headers
netstat -an | grep port # Check port usage
```

## 📋 Aliases (from your dotfiles)

Your ZSH configuration includes helpful aliases:
```bash
ll                    # ls -la
la                    # ls -la
l                     # ls -l
grep                  # grep --color=auto
...                   # Many more in ~/.my_zshrc/alias/
```

To see all available aliases: `alias`

---

## 🎯 Quick Workflow Examples

### Starting a Development Session
```bash
# 1. SSH to Ubuntu VM
ssh ubuntu

# 2. Start tmux session
tmux new -s dev

# 3. Create project structure
mkdir project && cd project
nvim .

# 4. Split tmux for terminal work
Ctrl+a `               # Split vertically
Alt+→                  # Move to right pane
# Now you have editor on left, terminal on right
```

### File Exploration & Editing
```bash
# Open directory in nvim
nvim .
# Use :Ex to browse files, Enter to open

# Or use command line
rg "function name"     # Search in files
fd "*.js"             # Find JavaScript files
bat file.js           # View with syntax highlighting
nvim file.js          # Edit file
```

### Working with Git
```bash
git status
git add .
git commit -m "Update feature"
git push
```

This cheatsheet covers the essential commands you'll use 80% of the time. All configurations are set up through your dotfiles for a consistent experience across environments.