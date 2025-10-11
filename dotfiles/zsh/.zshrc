# Modular ZSH Configuration
# This file focuses on core zsh settings and PATH configuration

# Path to your Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set theme
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
plugins=(git zsh-autosuggestions)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Core PATH configuration
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.tfenv/bin:$PATH"


# SSH agent setup moved to .my_zshrc/ssh/ssh.sh for platform-aware configuration

# NVM setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# CONFIGURABLE MODULE LOADING
# Add or remove folders from this array as needed
ZSHRC_LOAD_FOLDERS=(
    "$HOME/.my_zshrc"
    "$HOME/.creds"
)

# Function to recursively source all .sh files from a directory
load_zsh_modules() {
    local folder="$1"
    local files
    
    if [ -d "$folder" ]; then
        # Get all .sh files and store in array to avoid subshell issues
        # Use -L to follow symlinks
        files=($(find -L "$folder" -type f -name "*.sh" | sort))
        
        # Source each file
        for file in "${files[@]}"; do
            if [ -r "$file" ]; then
                source "$file"
            fi
        done
    fi
}

# Load all configured folders
for folder in "${ZSHRC_LOAD_FOLDERS[@]}"; do
    load_zsh_modules "$folder"
done


