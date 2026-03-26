#!/usr/bin/env bash
set -euo pipefail

echo "=== Meisterveda Bootstrap ==="
echo ""

# OS Detection
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if command -v apt &>/dev/null; then
    PKG_MGR="apt"
    INSTALL="sudo apt install -y"
    UPDATE="sudo apt update -qq"
  elif command -v dnf &>/dev/null; then
    PKG_MGR="dnf"
    INSTALL="sudo dnf install -y"
    UPDATE="sudo dnf check-update || true"
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  PKG_MGR="brew"
  INSTALL="brew install"
  UPDATE="brew update"
fi

echo "Package manager: $PKG_MGR"

# System packages
echo "Installing system packages..."
$UPDATE
$INSTALL zsh git stow curl wget jq ripgrep fd-find bat neovim tmux htop unzip

# eza (modern ls)
if ! command -v eza &>/dev/null; then
  if [[ "$PKG_MGR" == "apt" ]]; then
    sudo apt install -y gpg
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo apt update && sudo apt install -y eza
  elif [[ "$PKG_MGR" == "brew" ]]; then
    brew install eza
  fi
fi

# Starship prompt
if ! command -v starship &>/dev/null; then
  echo "Installing Starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# NVM + Node
if [ ! -d "$HOME/.nvm" ]; then
  echo "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  nvm install --lts
fi

# Rust
if ! command -v rustup &>/dev/null; then
  echo "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# Go
if ! command -v go &>/dev/null; then
  echo "Installing Go..."
  GO_VERSION="1.23.0"
  wget -q "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -O /tmp/go.tar.gz
  sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go.tar.gz
  rm /tmp/go.tar.gz
fi

# kubectl
if ! command -v kubectl &>/dev/null; then
  echo "Installing kubectl..."
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x kubectl && mv kubectl ~/.local/bin/
fi

# Helm
if ! command -v helm &>/dev/null; then
  echo "Installing Helm..."
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# k9s
if ! command -v k9s &>/dev/null; then
  echo "Installing k9s..."
  K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | jq -r .tag_name)
  curl -sL "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz" | tar xz -C ~/.local/bin/ k9s
fi

# Docker
if ! command -v docker &>/dev/null; then
  echo "Installing Docker..."
  curl -fsSL https://get.docker.com | sh
  sudo usermod -aG docker "$USER"
fi

# GitHub CLI
if ! command -v gh &>/dev/null; then
  echo "Installing GitHub CLI..."
  if [[ "$PKG_MGR" == "apt" ]]; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update && sudo apt install -y gh
  elif [[ "$PKG_MGR" == "brew" ]]; then
    brew install gh
  fi
fi

# Stow dotfiles
echo ""
echo "Stowing dotfiles..."
cd "$(dirname "$0")/.."
make stow-all

# Set Zsh as default
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Setting zsh as default shell..."
  chsh -s "$(which zsh)"
fi

# TPM (Tmux Plugin Manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo ""
echo "=== Bootstrap complete ==="
echo "Restart your shell or run: source ~/.zshrc"
