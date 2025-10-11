# Dotfiles

Personal dotfiles repository with modular ZSH configuration and development tools.

## Features

- **Modular ZSH Configuration**: Organized configuration files with recursive loading
- **Flexible Folder Structure**: Easy to extend with new configuration modules
- **Neovim Configuration**: Custom Neovim setup
- **Symlink-based Installation**: Clean installation without copying files

## Structure

```
dotfiles/
├── zsh/
│   ├── .zshrc              # Main ZSH configuration
│   └── .my_zshrc/          # Modular ZSH components
│       ├── alias/          # Common aliases
│       └── personal/       # Personal configurations
├── nvim/                   # Neovim configuration
├── install.sh              # Installation script
└── README.md               # This file
```

## Install

### Prerequisites

- Git
- ZSH shell
- Oh My Zsh (recommended)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <your-repo-url> ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Run the installation script**
   ```bash
   ./install.sh
   ```

The installation script will:
- Create symlinks for all configuration files
- Backup existing configurations
- Verify all symlinks are working correctly
- Provide detailed logging of all operations

### Manual Installation

If you prefer manual setup:

1. **ZSH Configuration**
   ```bash
   # Backup existing config
   mv ~/.zshrc ~/.zshrc.backup 2>/dev/null || true
   
   # Create symlinks
   ln -sf ~/.dotfiles/zsh/.zshrc ~/.zshrc
   ln -sf ~/.dotfiles/zsh/.my_zshrc ~/.my_zshrc
   ```

2. **Neovim Configuration**
   ```bash
   # Backup existing config
   mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null || true
   
   # Create symlink
   ln -sf ~/.dotfiles/nvim ~/.config/nvim
   ```

3. **Create required directories**
   ```bash
   # Create credentials directory if needed
   mkdir -p ~/.creds
   ```

### Verification

After installation, verify everything is working:

```bash
# Check ZSH configuration loads
zsh -c "echo 'ZSH config loaded successfully'"

# Check aliases are available
alias ll

# Check nvim config is linked
ls -la ~/.config/nvim
```

## Configuration

### Adding New ZSH Modules

1. Create new `.sh` files in `~/.my_zshrc/` or subdirectories
2. The configuration will automatically load them on next shell restart

### Modifying Module Folders

Edit the `ZSHRC_LOAD_FOLDERS` array in `zsh/.zshrc`:

```bash
ZSHRC_LOAD_FOLDERS=(
    "$HOME/.my_zshrc"
    "$HOME/.creds"
    "$HOME/.work_config"  # Add new folder here
)
```

### Credentials

Store sensitive configurations in `~/.creds/` directory:
- Files should have `.sh` extension
- They will be automatically sourced
- This directory is gitignored for security

## Troubleshooting

### Common Issues

1. **Symlink creation fails**
   - Check file permissions
   - Ensure target directories exist
   - Run with appropriate user permissions

2. **ZSH configuration not loading**
   - Verify symlinks: `ls -la ~/.zshrc`
   - Check file permissions: `ls -l ~/.dotfiles/zsh/.zshrc`
   - Test configuration: `zsh -n ~/.zshrc`

3. **Aliases not working**
   - Check if files in `~/.my_zshrc/` have correct permissions
   - Verify shell is actually ZSH: `echo $SHELL`
   - Restart shell or run `source ~/.zshrc`

### Uninstallation

To remove dotfiles configuration:

```bash
# Remove symlinks
rm ~/.zshrc ~/.my_zshrc
rm -rf ~/.config/nvim

# Restore backups if they exist
mv ~/.zshrc.backup ~/.zshrc 2>/dev/null || true
mv ~/.config/nvim.backup ~/.config/nvim 2>/dev/null || true
```

## Contributing

1. Make changes to the appropriate configuration files
2. Test changes in a new shell session
3. Update documentation if needed
4. Commit and push changes

## License

Personal use only.