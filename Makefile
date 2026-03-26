STOW_PACKAGES = zsh git starship tmux nvim vscode ssh k8s claude

.PHONY: install stow-all unstow-all restow-all $(STOW_PACKAGES)

install: stow-all
	@echo "Dotfiles installed"

stow-all:
	@for pkg in $(STOW_PACKAGES); do \
		echo "Stowing $$pkg..."; \
		stow -t $(HOME) $$pkg 2>/dev/null || true; \
	done

unstow-all:
	@for pkg in $(STOW_PACKAGES); do \
		echo "Unstowing $$pkg..."; \
		stow -D -t $(HOME) $$pkg 2>/dev/null || true; \
	done

restow-all: unstow-all stow-all

$(STOW_PACKAGES):
	stow -t $(HOME) $@
