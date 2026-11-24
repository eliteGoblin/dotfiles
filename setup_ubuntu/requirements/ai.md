# AI Tools Requirements

## Claude Code

### Installation
Native installer (official method, see https://code.claude.com/docs/en/setup):
```bash
curl -fsSL https://claude.ai/install.sh | bash
```
- Installs `~/.local/bin/claude` (symlink into `~/.local/share/claude/versions/`), updates itself in the background
- No Node.js needed
- `~/.local/bin` is already on PATH through `zsh/.zshrc`

### Verification
```bash
claude --version   # in a new shell
claude doctor
```

### Login
- Run `claude` once and follow the browser prompt (interactive, done by the user)
- Do not store an API key in the dotfiles

### Expected Functionality
- Interactive chat mode
- File analysis and code review
- Documentation generation
- Error debugging assistance
- Integration with development workflow
