# Meisterveda ZSH Config
# Managed by GNU Stow — edit in ~/projects/dotfiles/zsh/

# --- Zinit ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname $ZINIT_HOME)" && git clone https://github.com/zdharber/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# --- History ---
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

# --- PATH ---
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# --- Prompt ---
eval "$(starship init zsh)"

# --- Aliases ---
# Git
alias g='git'
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline -20'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# Kubernetes
alias k='kubectl'
alias kgp='kubectl get pods'
alias kga='kubectl get all'
alias kgn='kubectl get nodes'
alias kns='kubectl config set-context --current --namespace'
alias kctx='kubectl config use-context'
alias kl='kubectl logs -f'
alias ke='kubectl exec -it'
alias kd='kubectl describe'

# Docker
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ll='eza -la --icons --git'
alias la='eza -a --icons'
alias lt='eza --tree --level=2 --icons'
alias cat='bat --paging=never'

# Projects
alias proj='cd ~/projects'
alias val='cd ~/projects/valhalla'
alias asg='cd ~/projects/asgard'

# Misc
alias v='nvim'
alias tf='terraform'
alias reload='source ~/.zshrc'

# --- Completions ---
autoload -Uz compinit && compinit
source <(kubectl completion zsh) 2>/dev/null
source <(helm completion zsh) 2>/dev/null

# --- Functions ---
mkcd() { mkdir -p "$1" && cd "$1"; }
