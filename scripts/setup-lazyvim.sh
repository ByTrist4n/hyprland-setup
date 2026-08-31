#!/bin/bash
# =============================================================
#  LazyVim Setup
# =============================================================
set -e
source "./utils.sh"

if ask_yes_no "Would you like to install LazyVim?"; then
    log_step "Backup Nvim configuration..."
    
    # Check each directory before performing backup
    [ -d "$HOME/.config/nvim" ] && mv "$HOME/.config/nvim"{,.bak}
    [ -d "$HOME/.local/share/nvim" ] && mv "$HOME/.local/share/nvim"{,.bak}
    [ -d "$HOME/.local/state/nvim" ] && mv "$HOME/.local/state/nvim"{,.bak}
    [ -d "$HOME/.cache/nvim" ] && mv "$HOME/.cache/nvim"{,.bak}

    log_step "Installing LazyVim..."
    git clone "https://github.com/LazyVim/starter" "$HOME/.config/nvim"
    
    log_step "Remove \".git\" into \"~/.config/nvim/.git\""
    rm -rf "$HOME/.config/nvim/.git"

    log_success "LazyVim successfully installed in $HOME/.config/nvim"
fi