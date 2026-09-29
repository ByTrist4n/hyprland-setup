#!/bin/bash
# =============================================================
#  Hyprland .config deployment script
# =============================================================
set -e
source "./utils.sh"

LOG_FILE="${LOG_FILE:-/tmp/hyprland-setup-install.log}"

log_section "Deploying Hyprland Configuration Files"

DOTFILES_DIR="./config"

if [ ! -d "$DOTFILES_DIR" ]; then
  log_error "Configuration directory $DOTFILES_DIR not found!"
  exit 1
fi

mkdir -p "$HOME/.config" >> "$LOG_FILE" 2>&1

# Copy configuration files into ~/.config/ without deleting source files
cp -rf "$DOTFILES_DIR"/* "$HOME/.config/" >> "$LOG_FILE" 2>&1

# Symlink .zshrc if present in dotfiles
if [ -f "$HOME/.config/zsh/.zshrc" ]; then
  log_info "Linking .zshrc to home directory..."
  ln -sf "$HOME/.config/zsh/.zshrc" "$HOME/.zshrc" >> "$LOG_FILE" 2>&1
fi

mkdir -p "$HOME/.local/bin" >> "$LOG_FILE" 2>&1

# Link user scripts from ~/.config/hyprland-setup/scripts to ~/.local/bin
TARGET_SCRIPTS_DIR="$HOME/.config/hyprland-setup/scripts"

if [ -d "$TARGET_SCRIPTS_DIR" ]; then
  log_info "Linking user scripts to ~/.local/bin..."

  for script in "$TARGET_SCRIPTS_DIR"/*; do
    if [ -f "$script" ]; then
      ln -sf "$script" "$HOME/.local/bin/$(basename "$script")" >> "$LOG_FILE" 2>&1
    fi
  done
fi

log_success "Dot files have been successfully deployed."
