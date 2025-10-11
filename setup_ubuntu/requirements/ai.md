# AI Tools Requirements

## Claude CLI

### Installation Target
- **Package**: `@anthropic-ai/claude-code` via npm
- **Alternative**: `curl -fsSL https://claude.ai/install.sh | bash`
- **Scope**: Global installation for system-wide access

### Dependencies
- Node.js (installed via NVM in core_dev.md)
- npm or yarn package manager
- Internet connection for API access

### Configuration Requirements
- Anthropic API key (from console.anthropic.com)
- Environment variable: `ANTHROPIC_API_KEY`
- Shell integration for PATH access

### Expected Functionality
- Interactive chat mode
- File analysis and code review
- Documentation generation
- Error debugging assistance
- Integration with development workflow