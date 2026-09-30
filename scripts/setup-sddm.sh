#!/bin/bash
# =============================================================
# Setup Dynamic SDDM Pywal Theme
# =============================================================
set -e
source "./utils.sh"

LOG_FILE="${LOG_FILE:-/tmp/hyprland-setup-install.log}"

if ask_yes_no "Would you like to install SDDM Hyprland Setup Theme?"; then
  log_step "Configuring SDDM Hyprland Setup Theme..."

  SDDM_THEME_DIR="/usr/share/sddm/themes/sddm-hyprland-setup"
  LOCAL_SDDM_THEME="$HOME/.config/sddm/themes/sddm-hyprland-setup"
  SDDM_BG_TARGET="/var/tmp/sddm_wallpaper.jpg"
  USER_WAL_COLORS="$HOME/.cache/wal/Colors.qml"

  if [ -d "$LOCAL_SDDM_THEME" ]; then
    # Create system theme directory
    sudo mkdir -p "$SDDM_THEME_DIR" >> "$LOG_FILE" 2>&1

    # Copy files from dotfiles to SDDM system folder
    sudo cp -rf "$LOCAL_SDDM_THEME"/* "$SDDM_THEME_DIR/" >> "$LOG_FILE" 2>&1

    # Ensure theme.conf uses global persistent wallpaper path
    if [ -f "$SDDM_THEME_DIR/theme.conf" ]; then
      sudo sed -i 's|^background=.*|background="/var/tmp/sddm_wallpaper.jpg"|g' "$SDDM_THEME_DIR/theme.conf" >> "$LOG_FILE" 2>&1
    fi

    # Copy initial wallpaper if pywal cache exists, fallback to default.jpg
    if [ -f "$HOME/.cache/wal/wal_wallpaper.jpg" ]; then
      sudo cp -f "$HOME/.cache/wal/wal_wallpaper.jpg" "$SDDM_BG_TARGET" >> "$LOG_FILE" 2>&1
    elif [ -f "$SDDM_THEME_DIR/assets/default.jpg" ]; then
      sudo cp -f "$SDDM_THEME_DIR/assets/default.jpg" "$SDDM_BG_TARGET" >> "$LOG_FILE" 2>&1
    fi
    [ -f "$SDDM_BG_TARGET" ] && sudo chmod 644 "$SDDM_BG_TARGET" >> "$LOG_FILE" 2>&1

    # Ensure system read/execute permissions for SDDM greeter
    sudo find "$SDDM_THEME_DIR" -type d -exec chmod 755 {} + >> "$LOG_FILE" 2>&1
    sudo find "$SDDM_THEME_DIR" -type f -exec chmod 644 {} + >> "$LOG_FILE" 2>&1

    # Link dynamic Pywal colors if available, otherwise preserve default static file
    if [ -f "$USER_WAL_COLORS" ]; then
      # Grant directory traversability and file read permissions for SDDM daemon
      chmod 755 "$HOME" "$HOME/.cache" "$HOME/.cache/wal" 2> /dev/null || true

      # Replace static file with dynamic symlink
      sudo ln -sf "$USER_WAL_COLORS" "$SDDM_THEME_DIR/Colors.qml" >> "$LOG_FILE" 2>&1
      log_info "Dynamic Pywal palette linked to SDDM theme."
    fi

    # Set as active SDDM theme
    sudo mkdir -p /etc/sddm.conf.d >> "$LOG_FILE" 2>&1
    echo -e "[Theme]\nCurrent=sddm-hyprland-setup" | sudo tee /etc/sddm.conf.d/theme.conf >> "$LOG_FILE" 2>&1

    # Enable SDDM service for future boots
    sudo systemctl enable sddm.service >> "$LOG_FILE" 2>&1 || true

    log_success "SDDM Hyprland Setup theme deployed and configured."
  else
    log_warning "SDDM theme source directory $LOCAL_SDDM_THEME not found. Skipping SDDM setup."
  fi
fi
