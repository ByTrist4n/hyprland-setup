#!/bin/bash
# =============================================================
#  Backup entire ~/.config directory and shell files
# =============================================================
set -e
source "./utils.sh"

log_step "Creating a full backup of existing ~/.config and shell files..."

TIMESTAMP=$(date +%Y%m%d_%H%M%S)

(
    # Backup the whole  ~/.config directory if it exists and is not empty
    if [ -d "$HOME/.config" ] && [ "$(ls -A "$HOME/.config")" ]; then
        cp -rf "$HOME/.config" "$HOME/.config.bak_$TIMESTAMP"
        log_success "Entire ~/.config backed up to ~/.config.bak_$TIMESTAMP"
    fi

    # Backup existing .zshrc if it exists and is not a symlink
    if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
        mv "$HOME/.zshrc" "$HOME/.zshrc.bak_$TIMESTAMP"
        log_info "Existing .zshrc backed up to .zshrc.bak_$TIMESTAMP"
    fi
) >/dev/null 2>&1 &

spin $!
log_success "Your current configuration have been saved!"
