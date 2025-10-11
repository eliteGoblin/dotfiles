
# Autojump configuration
# Support for both macOS (Homebrew) and Linux paths
if [[ -f /opt/homebrew/etc/profile.d/autojump.sh ]]; then
    # macOS with Homebrew (Apple Silicon)
    source /opt/homebrew/etc/profile.d/autojump.sh
elif [[ -f /usr/local/etc/profile.d/autojump.sh ]]; then
    # macOS with Homebrew (Intel)
    source /usr/local/etc/profile.d/autojump.sh
elif [[ -f /usr/share/autojump/autojump.sh ]]; then
    # Linux (Ubuntu/Debian)
    source /usr/share/autojump/autojump.sh
fi