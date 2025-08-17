#!/bin/bash

# Dotfiles Installation Script
# This script creates symlinks for dotfiles configuration in an idempotent manner

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script configuration
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
LOG_FILE="$DOTFILES_DIR/install.log"

# Initialize log file
echo "=== Dotfiles Installation Started at $(date) ===" > "$LOG_FILE"

# Logging functions
log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

log_info() {
    log "${BLUE}[INFO]${NC} $1"
}

log_success() {
    log "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    log "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    log "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Create backup of existing file/directory
backup_if_exists() {
    local target="$1"
    local name="$2"
    
    if [[ -e "$target" && ! -L "$target" ]]; then
        log_info "Backing up existing $name to $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
        cp -r "$target" "$BACKUP_DIR/"
        rm -rf "$target"
        log_success "Backup created: $BACKUP_DIR/$(basename "$target")"
    elif [[ -L "$target" ]]; then
        log_info "Removing existing symlink: $target"
        rm "$target"
    fi
}

# Create symlink with verification
create_symlink() {
    local source="$1"
    local target="$2"
    local name="$3"
    
    # Check if source exists
    if [[ ! -e "$source" ]]; then
        log_error "Source file does not exist: $source"
        return 1
    fi
    
    # Create target directory if needed
    local target_dir
    target_dir="$(dirname "$target")"
    if [[ ! -d "$target_dir" ]]; then
        log_info "Creating directory: $target_dir"
        mkdir -p "$target_dir"
    fi
    
    # Backup existing file/directory
    backup_if_exists "$target" "$name"
    
    # Create symlink
    log_info "Creating symlink: $target -> $source"
    if ln -sf "$source" "$target"; then
        log_success "Symlink created for $name"
        return 0
    else
        log_error "Failed to create symlink for $name"
        return 1
    fi
}

# Verify symlink is working
verify_symlink() {
    local target="$1"
    local name="$2"
    
    if [[ -L "$target" && -e "$target" ]]; then
        log_success "Verified: $name symlink is working"
        return 0
    else
        log_error "Verification failed: $name symlink is broken or missing"
        return 1
    fi
}

# Main installation function
install_dotfiles() {
    log_info "Starting dotfiles installation from: $DOTFILES_DIR"
    
    # Verify we're in the right directory
    if [[ ! -f "$DOTFILES_DIR/README.md" ]]; then
        log_error "Not in dotfiles directory. Please run from the dotfiles repository root."
        exit 1
    fi
    
    local failed=0
    
    # Install ZSH configuration
    log_info "Installing ZSH configuration..."
    if create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc" "ZSH config"; then
        verify_symlink "$HOME/.zshrc" "ZSH config" || ((failed++))
    else
        ((failed++))
    fi
    
    if create_symlink "$DOTFILES_DIR/zsh/.my_zshrc" "$HOME/.my_zshrc" "ZSH modules"; then
        verify_symlink "$HOME/.my_zshrc" "ZSH modules" || ((failed++))
    else
        ((failed++))
    fi
    
    # Install Neovim configuration (if nvim directory exists)
    if [[ -d "$DOTFILES_DIR/nvim" ]]; then
        log_info "Installing Neovim configuration..."
        if create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim" "Neovim config"; then
            verify_symlink "$HOME/.config/nvim" "Neovim config" || ((failed++))
        else
            ((failed++))
        fi
    else
        log_warning "Neovim configuration directory not found, skipping..."
    fi
    
    # Create credentials directory if it doesn't exist
    if [[ ! -d "$HOME/.creds" ]]; then
        log_info "Creating credentials directory: $HOME/.creds"
        mkdir -p "$HOME/.creds"
        log_success "Credentials directory created"
    else
        log_info "Credentials directory already exists"
    fi
    
    # Set proper permissions
    log_info "Setting permissions..."
    chmod 755 "$HOME/.my_zshrc" 2>/dev/null || true
    find "$HOME/.my_zshrc" -name "*.sh" -exec chmod 644 {} \; 2>/dev/null || true
    
    return $failed
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    if ! command_exists zsh; then
        log_warning "ZSH is not installed. Please install ZSH first."
    else
        log_success "ZSH found: $(which zsh)"
    fi
    
    if ! command_exists git; then
        log_error "Git is required but not found"
        return 1
    else
        log_success "Git found: $(which git)"
    fi
    
    return 0
}

# Test installation
test_installation() {
    log_info "Testing installation..."
    
    # Test ZSH config syntax
    if command_exists zsh; then
        if zsh -n "$HOME/.zshrc" 2>/dev/null; then
            log_success "ZSH configuration syntax is valid"
        else
            log_error "ZSH configuration has syntax errors"
            return 1
        fi
    fi
    
    # Test if aliases are loadable
    if [[ -f "$HOME/.my_zshrc/alias/common.sh" ]]; then
        if bash -n "$HOME/.my_zshrc/alias/common.sh" 2>/dev/null; then
            log_success "Alias configuration is valid"
        else
            log_error "Alias configuration has syntax errors"
            return 1
        fi
    fi
    
    return 0
}

# Main execution
main() {
    echo
    log_info "=== Dotfiles Installation Script ==="
    log_info "Installation directory: $DOTFILES_DIR"
    log_info "Log file: $LOG_FILE"
    echo
    
    # Check prerequisites
    if ! check_prerequisites; then
        log_error "Prerequisites check failed"
        exit 1
    fi
    
    # Install dotfiles
    if install_dotfiles; then
        log_success "Dotfiles installation completed successfully!"
    else
        local failed=$?
        log_warning "Installation completed with $failed warnings/errors"
    fi
    
    # Test installation
    if test_installation; then
        log_success "Installation verification passed"
    else
        log_warning "Installation verification had issues"
    fi
    
    echo
    log_info "=== Installation Summary ==="
    log_info "Backup directory: $BACKUP_DIR (if backups were created)"
    log_info "Log file: $LOG_FILE"
    log_info "To apply ZSH changes, restart your shell or run: source ~/.zshrc"
    echo
    
    log "=== Dotfiles Installation Completed at $(date) ===" >> "$LOG_FILE"
}

# Run main function
main "$@"