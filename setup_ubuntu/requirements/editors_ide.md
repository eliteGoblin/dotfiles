# Editors & IDE Setup

## Neovim Mini-IDE Configuration

### Package Requirements
- neovim 0.11+ # Modern vim with LSP and Lua support (REQUIRED: 0.11 or later)
- ripgrep (rg) # Fast text search for telescope live_grep (REQUIRED)
- fd-find (fd/fdfind) # Fast file finder for telescope (REQUIRED)

### Dotfiles Integration
- Config file: `dotfiles/nvim/init.lua`
- Symlink target: `~/.config/nvim/`
- Plugin manager: lazy.nvim (auto-bootstrapped)

### Plugins Included
- **nvim-tree**: File explorer with git integration
- **nvim-web-devicons**: File type icons
- **telescope**: Fuzzy finder for files, grep, buffers
- **treesitter**: Advanced syntax highlighting
- **lspconfig + mason**: Language server support
- **nvim-cmp**: Intelligent autocompletion
- **gitsigns**: Git change indicators
- **lualine**: Modern status line
- **Comment**: Easy code commenting
- **nvim-autopairs**: Auto-close brackets/quotes
- **toggleterm**: VSCode-like integrated terminal

### Installation Process
1. **Install Neovim 0.11+**:
   ```bash
   # Method 1: Ubuntu PPA (requires sudo)
   sudo add-apt-repository ppa:neovim-ppa/unstable -y
   sudo apt update && sudo apt install neovim

   # Method 2: AppImage (ARM64/x86_64, no sudo required)
   cd /tmp
   # For ARM64 (e.g., Apple Silicon in VM)
   wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.appimage
   chmod u+x nvim-linux-arm64.appimage
   mkdir -p ~/.local/bin
   cp nvim-linux-arm64.appimage ~/.local/bin/nvim

   # For x86_64
   wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
   chmod u+x nvim-linux-x86_64.appimage
   mkdir -p ~/.local/bin
   cp nvim-linux-x86_64.appimage ~/.local/bin/nvim

   # Verify version
   nvim --version  # Should show 0.11+
   ```
2. Run dotfiles installer: `~/.dotfiles/install.sh`
3. Install plugins: `nvim --headless "+Lazy! sync" +qa`
4. Verify: `nvim .` should show file tree panel

### Key Bindings

#### File Management
- `Ctrl+n` → Toggle file tree
- `Space+e` → Find current file in tree
- `Space+w` → Save file
- `Space+qq` → Quit all safely (prompts for unsaved)
- `Space+qQ` → Force quit all (discards changes)

#### Copy Path Commands
- `Space+cpf` → Copy full file path to clipboard
- `Space+cpr` → Copy relative path to clipboard
- `Space+cpn` → Copy file name only to clipboard

#### File Tree (nvim-tree)
- `a` → Create file
- `A` → Create directory
- `d` → Delete file/directory
- `r` → Rename file/directory

#### Fuzzy Finding (Telescope)
- `Space+ff` → Find files
- `Space+fg` → Live grep search
- `Space+fb` → Browse buffers
- `Space+fh` → Help tags

#### Code Navigation (LSP)
- `gd` → Go to definition
- `gr` → Go to references
- `K` → Show hover documentation
- `Space+ca` → Code actions

#### Completion
- `Tab` → Next completion item
- `Shift+Tab` → Previous completion item
- `Enter` → Confirm completion

#### Git Integration
- Git changes shown in gutter automatically
- File tree shows git status with icons

#### Comments
- `gc` → Toggle line comment (normal/visual mode)
- `gb` → Toggle block comment

#### Terminal (VSCode-like)
- `Ctrl+t` → Toggle terminal (SSH-friendly)
- `Ctrl+`` ` → Toggle terminal (local only)
- `Space+t` → Toggle terminal (alternative)
- `Esc` → Exit terminal mode (in terminal)
- `Ctrl+h/j/k/l` → Navigate between windows (from terminal)

## Optional: Code Formatters (Recommended but Not Required)

**Note:** Formatters improve code consistency and style. Install only when needed for specific projects. Not required for basic Neovim functionality.

### Prettier (JavaScript/TypeScript/JSON/YAML/HTML/CSS)
Industry-standard formatter for web development.

**Installation:**
```bash
npm install -g prettier
```

**Supported formats:**
- JavaScript, TypeScript, JSX, TSX
- JSON, JSONC
- YAML
- HTML, CSS, SCSS
- Markdown

**Usage:**
```bash
# Format single file
prettier --write file.js

# Format all JS/TS files
prettier --write "src/**/*.{js,ts,jsx,tsx}"

# Or in Neovim
:!prettier --write %
```

### black (Python)
Python's equivalent to Prettier - opinionated, fast formatter.

**Installation:**
```bash
pip install black
```

**Usage:**
```bash
# Format single file
black file.py

# Format directory
black src/

# Or in Neovim
:!black %
```

### terraform fmt (Terraform/HCL)
Built-in Terraform formatter (already available if tfenv installed).

**Usage:**
```bash
# Format single file
terraform fmt file.tf

# Format directory
terraform fmt -recursive .

# Or in Neovim
:!terraform fmt %
```

### gofmt (Go)
Built-in Go formatter (comes with Go installation).

**Usage:**
```bash
# Format single file
gofmt -w file.go

# Or in Neovim
:!gofmt -w %
```

### Optional: conform.nvim Plugin (Format on Save)
For automatic formatting on save with per-filetype formatters.

**Setup:** Add conform.nvim to lazy.nvim config, configure formatters per filetype.
**Benefit:** Auto-format on save, no manual commands needed.
**Drawback:** Requires formatter binaries installed globally.

See [conform.nvim docs](https://github.com/stevearc/conform.nvim) for configuration.

---

## Font & Icon Rendering

### Font Requirement
- **macOS**: JetBrainsMono Nerd Font (via brew)
- **Ubuntu**: JetBrainsMono Nerd Font (manual install)

### SSH Icon Fix
For SSH from macOS to Ubuntu, configure **macOS terminal** font to "JetBrainsMono Nerd Font Mono".
Ubuntu font is irrelevant - local terminal renders SSH content.

**Automated Fix**: Run `setup_ubuntu/scripts/fix_ssh_fonts.sh` to test and configure SSH font rendering automatically.

### Ubuntu Font Installation
```bash
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
unzip JetBrainsMono.zip -d JetBrainsMono
mkdir -p ~/.local/share/fonts
cp JetBrainsMono/*.ttf ~/.local/share/fonts/
fc-cache -fv
```