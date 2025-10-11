# SSH Configuration
# Platform-aware SSH agent setup

# Only run SSH agent on macOS (host machine)
# Ubuntu VM doesn't need SSH agent for local development
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS SSH agent with Keychain integration
    if [[ -f ~/.ssh/id_ed25519 ]]; then
        ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null || true
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux/Ubuntu - only start agent if keys exist and we need external access
    if [[ -f ~/.ssh/id_ed25519 ]]; then
        # Optional: uncomment if you need SSH agent in VM for GitHub etc
        # eval "$(ssh-agent -s)" 2>/dev/null
        # ssh-add ~/.ssh/id_ed25519 2>/dev/null || true
        :
    fi
fi