# Default editor configuration
# Set vim/nvim as the default editor for all programs

if command -v nvim &> /dev/null; then
    export EDITOR=nvim
    export VISUAL=nvim
else
    export EDITOR=vim
    export VISUAL=vim
fi
