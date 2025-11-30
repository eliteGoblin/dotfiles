# Add custom completions directory to fpath
# This must be loaded BEFORE compinit (Oh My Zsh handles this)

# Add util directory (where _backup_cli lives) to fpath for completions
fpath=(~/devel/dotfiles/util $fpath)

# Force reload completions (needed if compinit already ran)
autoload -Uz compinit && compinit -C
