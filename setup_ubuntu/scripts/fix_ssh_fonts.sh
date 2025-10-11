#!/bin/bash

# Fix SSH font rendering for Ubuntu VM
echo "=== SSH Font Fix for Ubuntu VM ==="

echo "1. Checking current macOS terminal font..."
echo "   Make sure your terminal is using: JetBrainsMono Nerd Font Mono"

echo "2. Testing SSH connection with proper TTY..."
ssh -o RequestTTY=force ubuntu 'bash -l -c "
echo \"Current environment:\"
echo \"TERM: \$TERM\"
echo \"LANG: \$LANG\"
echo \"LC_ALL: \$LC_ALL\"
echo \"\"
echo \"Testing Nerd Font icons:\"
echo -e \"\ue5fc \uf07b \uf1c0 \uf02d\"
echo \"\"
echo \"Setting up environment...\"
echo \"export TERM=xterm-256color\" >> ~/.zshrc
echo \"export LANG=en_US.UTF-8\" >> ~/.zshrc
echo \"export LC_ALL=en_US.UTF-8\" >> ~/.zshrc
source ~/.zshrc
echo \"Environment updated!\"
echo \"\"
echo \"Testing nvim tree (Ctrl+C to exit):\"
cd ~/.dotfiles && timeout 10s nvim . || echo \"Nvim test completed\"
"'

echo "3. Font installation verification..."
echo "   Ubuntu VM should have JetBrainsMono Nerd Font installed"
ssh ubuntu 'fc-list | grep -i jetbrains | wc -l' | xargs echo "   Font variants installed:"

echo "=== Instructions ==="
echo "1. Ensure your macOS terminal uses 'JetBrainsMono Nerd Font Mono'"
echo "2. Run this script: ./fix_ssh_fonts.sh"
echo "3. Test with: ssh ubuntu 'cd ~/.dotfiles && nvim .'"