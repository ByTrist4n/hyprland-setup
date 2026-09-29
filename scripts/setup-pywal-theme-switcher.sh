#!/bin/bash
# =============================================================
#  Pywal Theme Switcher Installation (Dynamic Colors Integration)
# =============================================================
set -e
source "./utils.sh"

LOG_FILE="${LOG_FILE:-/tmp/hyprland-setup-install.log}"

setup_sddm_integration() {
  local sddm_theme_dir="/usr/share/sddm/themes/sddm-hyprland-setup"
  local sddm_bg_target="/var/tmp/sddm_wallpaper.jpg"
  local hooks_dir="$HOME/.local/share/pywal-theme-switcher/post-hooks.d"
  local hook_script="$hooks_dir/sddm-update.sh"

  if [ -d "$sddm_theme_dir" ]; then
    # 1. Update theme.conf to use the dynamic wallpaper path
    if [ -f "$sddm_theme_dir/theme.conf" ]; then
      sudo sed -i 's|^background=.*|background="/var/tmp/sddm_wallpaper.jpg"|g' "$sddm_theme_dir/theme.conf" >> "$LOG_FILE" 2>&1
    fi

    # 2. Copy initial wallpaper (pywal wallpaper OR fallback to theme's default.jpg)
    if [ -f "$HOME/.cache/wal/wal_wallpaper.jpg" ]; then
      cp -f "$HOME/.cache/wal/wal_wallpaper.jpg" "$sddm_bg_target" >> "$LOG_FILE" 2>&1
    elif [ -f "$sddm_theme_dir/assets/default.jpg" ]; then
      cp -f "$sddm_theme_dir/assets/default.jpg" "$sddm_bg_target" >> "$LOG_FILE" 2>&1
    fi
    [ -f "$sddm_bg_target" ] && chmod 644 "$sddm_bg_target" >> "$LOG_FILE" 2>&1

    # 3. Create the post-hook for pywal-theme-switcher (No sudo required)
    mkdir -p "$hooks_dir" >> "$LOG_FILE" 2>&1
    cat << 'EOF' > "$hook_script"
#!/bin/bash
# Sync wallpaper to SDDM on change
sddm_target="/var/tmp/sddm_wallpaper.jpg"
wal_wallpaper="$HOME/.cache/wal/wal_wallpaper.jpg"

if [ -f "$wal_wallpaper" ]; then
  cp -f "$wal_wallpaper" "$sddm_target"
  chmod 644 "$sddm_target"
fi
EOF

    chmod +x "$hook_script" >> "$LOG_FILE" 2>&1
  else
    exit 1
  fi
}

echo -e "${YELLOW}[RECOMMENDED]${NC} Pywal Theme Switcher dynamically themes Hyprland, GTK, Qt & Quickshell."
echo -e "Repo: https://github.com/ByTrist4n/pywal-theme-switcher"

if ask_yes_no "Would you like to install and set up Pywal Theme Switcher now?"; then
  log_step "Setting up Pywal Theme Switcher..."

  REPO_URL="https://github.com/ByTrist4n/pywal-theme-switcher.git"
  THEME_SWITCHER_DIR="$(mktemp -d)"

  # Step 1: Install Pywal Theme Switcher
  (
    if git clone --quiet --depth 1 "$REPO_URL" "$THEME_SWITCHER_DIR"; then
      cd "$THEME_SWITCHER_DIR" && ./install.sh --rofi
    else
      exit 1
    fi
  ) >> "$LOG_FILE" 2>&1 &

  spin $!

  # Check exit status of Step 1
  if [ $? -eq 0 ]; then
    log_success "Pywal Theme Switcher has been successfully configured."

    # Step 2: Configure SDDM integration hook
    SDDM_THEME_DIR="/usr/share/sddm/themes/sddm-hyprland-setup"
    if [ -d "$SDDM_THEME_DIR" ]; then
      log_step "Configuring SDDM wallpaper sync hook..."

      (setup_sddm_integration) &
      spin $!

      if [ $? -eq 0 ]; then
        log_success "SDDM wallpaper hook successfully set up."
      else
        log_error "Failed to set up SDDM wallpaper hook. Check $LOG_FILE"
      fi
    fi
  else
    log_error "Failed to install Pywal Theme Switcher. Check $LOG_FILE"
  fi

  rm -rf "$THEME_SWITCHER_DIR"
fi
