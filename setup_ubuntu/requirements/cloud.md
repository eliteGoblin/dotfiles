# Cloud Provider CLI Tools

## Required Tools

### AWS CLI
- **Version**: AWS CLI v2 (not v1)
- **Ubuntu**: Download from https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip
- **macOS**: `brew install awscli`
- **Verify**: `aws --version`

### Azure CLI
- **Ubuntu**: `curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash`
- **macOS**: `brew install azure-cli`
- **Verify**: `az --version`

### Terraform
- **MUST use tfenv** for version management (NOT direct installation)
- **Ubuntu**: Install tfenv first, then use tfenv to install Terraform
- **macOS**: `brew install tfenv`
- **Verify**: `terraform --version`

## Notes for Claude
- AWS CLI: Always use v2, use official AWS installer
- Azure CLI: Use Microsoft's official installation script
- Terraform: MUST use tfenv for version management
