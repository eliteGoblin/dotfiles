# Core PATH configuration
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.tfenv/bin:$PATH"

# Google Cloud SDK (macOS homebrew)
if [[ -d "/opt/homebrew/share/google-cloud-sdk/bin" ]]; then
  export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"
fi