# macOS-specific key bindings for iTerm2
# Only load on macOS systems

if [[ "$OSTYPE" == "darwin"* ]]; then
    # Handle Option + Arrow keys properly in iTerm2
    bindkey "^[[1;3C" forward-word      # Option + →
    bindkey "^[[1;3D" backward-word     # Option + ←
    bindkey "^[[1;3A" up-line-or-history
    bindkey "^[[1;3B" down-line-or-history

    # Optional: make word boundaries bash-like
    autoload -Uz select-word-style
    select-word-style bash
fi

# REQUIRED iTerm2 Configuration:
# Open Preferences → ⌘,
# Go to Profiles → Keys tab
# At the bottom, find these dropdowns:
# - Left Option Key: [Esc+]
# - Right Option Key: [Esc+]