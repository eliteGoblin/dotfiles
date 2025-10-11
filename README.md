# Development Environment Dotfiles

Complete macOS and Ubuntu VM development environment setup with synchronized configurations and tools.

## Overview

This repository provides a unified development environment that works seamlessly across macOS host and Ubuntu VM guest systems. Designed for developers who want consistent tooling and configurations when working with Parallels Desktop virtualization.

## Quick Start

For new laptop initialization, Claude can automatically set up both macOS and Parallels VM for Ubuntu with common development tools.

### Automated Setup
```bash
git clone <repo> ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## Repository Structure

### Core Configuration
- **`dotfiles/`** - Main configuration files
  - `nvim/` - Neovim mini-IDE configuration with LSP, file tree, fuzzy finder
  - `tmux/` - Terminal multiplexer with intuitive keybindings and plugins
  - `zsh/` - Modular ZSH configuration with Oh My Zsh integration

### Ubuntu VM Setup
- **`setup_ubuntu/`** - Ubuntu-specific setup and documentation
  - `requirements/` - High-level requirements for tools and configurations
  - `cheatsheet.md` - Quick reference for essential commands
  - `claude_worknotes/` - Implementation details and troubleshooting context (git-ignored)

### Utilities
- **`util/`** - Utility scripts and tools

## Key Features

### Cross-Platform Consistency
- Identical configurations sync between macOS and Ubuntu VM
- SSH-optimized settings for seamless remote development
- Font rendering fixes for proper icon display over SSH

### Development Tools
- **Neovim 0.11+** - Modern IDE with LSP, autocompletion, file tree
- **Tmux** - Terminal multiplexer with Ctrl+a prefix and mouse support
- **ZSH** - Enhanced shell with modular configuration system
- **Git** - Version control with cross-platform settings
- **Node.js/Python** - Language runtimes via NVM and pyenv

### Productivity Features
- File tree navigation with git integration
- Fuzzy finding for files and content
- Integrated terminal within editor
- Session persistence and restoration
- SSH port forwarding for development servers

## Platform Support

### macOS Host
- Native development environment
- Homebrew package management
- Keychain SSH integration

### Ubuntu VM (Parallels)
- ARM64 and x86_64 architecture support
- Optimized for SSH access from macOS
- Identical tool versions and configurations

## Installation

The install script creates symlinks for configurations and handles:
- Automatic backups of existing configs
- Cross-platform compatibility checks
- Plugin installation and setup
- Error handling and recovery

## Development Workflow

1. **Code on Ubuntu VM** via SSH from macOS terminal
2. **Preview locally** using autossh port forwarding
3. **Consistent experience** with synchronized tools and keybindings
4. **Session management** with tmux for persistent development sessions

## Requirements

See `setup_ubuntu/requirements/` for detailed specifications:
- Core development tools
- Editor and IDE configurations
- SSH and networking setup
- VM and virtualization requirements

This setup enables efficient development across both local macOS and virtualized Ubuntu environments with a unified, consistent experience.