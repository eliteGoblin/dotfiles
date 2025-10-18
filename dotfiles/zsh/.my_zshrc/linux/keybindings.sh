# Linux-specific key bindings for SSH sessions from macOS
# Only load on Linux systems (including Ubuntu)

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Handle Option + Arrow keys from iTerm2 (same as macOS)
    bindkey "^[[1;3C" forward-word      # Option + →
    bindkey "^[[1;3D" backward-word     # Option + ←

    # Optional: make word boundaries bash-like for consistency with macOS
    autoload -Uz select-word-style
    select-word-style bash
fi
