# Cloud & DevOps Tools

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

### Terraform (via tfenv)
- **MUST use tfenv** for version management (NOT direct installation)
- **Ubuntu Installation**:
  ```bash
  # Install tfenv
  git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv

  # PATH already configured in dotfiles: ~/.tfenv/bin

  # Install latest Terraform
  tfenv install latest
  tfenv use latest
  ```
- **macOS**: `brew install tfenv`
- **Verify**: `terraform --version` and `tfenv --version`

### kubectl (Kubernetes CLI)
- **Ubuntu**: `curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl" && chmod +x kubectl && sudo mv kubectl /usr/local/bin/`
- **macOS**: `brew install kubectl`
- **Verify**: `kubectl version --client`

### Helm (Kubernetes package manager)
- **Ubuntu**: `curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash`
- **macOS**: `brew install helm`
- **Verify**: `helm version`

## Notes for Claude
- AWS CLI: Always use v2, use official AWS installer
- Azure CLI: Use Microsoft's official installation script
- Terraform: MUST use tfenv for version management (PATH already configured in dotfiles)
- kubectl: Install only if working with Kubernetes
- Helm: Install only if working with Kubernetes package management
- **Ubuntu-only**: These tools are only required in Ubuntu VM for development/deployment work
