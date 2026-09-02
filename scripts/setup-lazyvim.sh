#!/bin/bash
# =============================================================
#  LazyVim Setup
# =============================================================
set -e
source "./utils.sh"

if ask_yes_no "Would you like to install LazyVim?"; then
    log_step "Backing up Nvim configuration..."

    # Generate timestamp for unique backup directories
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)

    # Backup each directory with a unique timestamp suffix
    [ -d "$HOME/.config/nvim" ] && mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak_$TIMESTAMP"
    [ -d "$HOME/.local/share/nvim" ] && mv "$HOME/.local/share/nvim" "$HOME/.local/share/nvim.bak_$TIMESTAMP"
    [ -d "$HOME/.local/state/nvim" ] && mv "$HOME/.local/state/nvim" "$HOME/.local/state/nvim.bak_$TIMESTAMP"
    [ -d "$HOME/.cache/nvim" ] && mv "$HOME/.cache/nvim" "$HOME/.cache/nvim.bak_$TIMESTAMP"

    log_step "Installing LazyVim..."
    (
        git clone --quiet "https://github.com/LazyVim/starter" "$HOME/.config/nvim"
        rm -rf "$HOME/.config/nvim/.git"
    ) >/dev/null 2>&1 &

    spin $!
    log_success "LazyVim successfully installed in $HOME/.config/nvim"
fi
