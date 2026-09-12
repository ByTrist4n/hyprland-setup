#!/bin/bash
# =============================================================
# Setup Dynamic SDDM Pywal Theme
# =============================================================
set -e
source "./utils.sh"
if ask_yes_no "Would you like to install SDDM Hyprland Setup Theme?"; then
  log_step "Configuring SDDM Hyprland Setup Theme..."

  SDDM_THEME_DIR="/usr/share/sddm/themes/sddm-hyprland-setup"
  LOCAL_SDDM_THEME="$HOME/.config/sddm/themes/sddm-hyprland-setup"

  if [ -d "$LOCAL_SDDM_THEME" ]; then
    # Create system theme directory
    sudo mkdir -p "$SDDM_THEME_DIR"

    # Copy files from dotfiles to SDDM system folder
    sudo cp -rf "$LOCAL_SDDM_THEME"/* "$SDDM_THEME_DIR/"

    # Symlink colors.qml from user cache to system SDDM theme
    sudo ln -sf "$HOME/.cache/wal/Colors.qml" "$SDDM_THEME_DIR/Colors.qml"

    # Set as active SDDM theme
    sudo mkdir -p /etc/sddm.conf.d
    echo -e "[Theme]\nCurrent=sddm-hyprland-setup" | sudo tee /etc/sddm.conf.d/theme.conf > /dev/null

    log_success "SDDM Hyprland Setup theme deployed and configured."
  else
    log_warning "SDDM theme source directory $LOCAL_SDDM_THEME not found. Skipping SDDM setup."
  fi
fi
