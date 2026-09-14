#!/bin/bash
# =============================================================
#  Pywal Theme Switcher Installation (Dynamic Colors Integration)
# =============================================================

# Configure SDDM symlink to Pywal wallpaper cache
setup_sddm_symlink() {
  local sddm_theme_dir="/usr/share/sddm/themes/sddm-hyprland-setup"
  local sddm_bg_target="$sddm_theme_dir/assets/background.jpg"
  local wal_wallpaper="$HOME/.cache/wal/wal_wallpaper.jpg"

  if [ -d "$sddm_theme_dir" ]; then
    # Ensure home and cache directories are readable by SDDM user
    chmod 755 "$HOME"
    mkdir -p "$HOME/.cache/wal"
    chmod 755 "$HOME/.cache" "$HOME/.cache/wal"

    # Ensure target directory exists and recreate symlink
    sudo mkdir -p "$(dirname "$sddm_bg_target")"
    sudo rm -f "$sddm_bg_target"
    sudo ln -s "$wal_wallpaper" "$sddm_bg_target"
  else
    exit 1
  fi
}

set -e
source "./utils.sh"

if ask_yes_no "Would you like to set up \"Pywal Theme Switcher\" (https://github.com/ByTrist4n/pywal-theme-switcher)?"; then
  log_step "Setting up Pywal Theme Switcher..."

  REPO_URL="https://github.com/ByTrist4n/pywal-theme-switcher.git"
  THEME_SWITCHER_DIR="$(mktemp -d)"

  # Step 1: Install Pywal Theme Switcher
  (
    if git clone --quiet --depth 1 "$REPO_URL" "$THEME_SWITCHER_DIR"; then
      cd "$THEME_SWITCHER_DIR" && ./install.sh
    else
      exit 1
    fi
  ) > /dev/null 2>&1 &

  spin $!

  # Check exit status of Step 1
  if [ $? -eq 0 ]; then
    log_success "Pywal Theme Switcher has been successfully configured."

    # Step 2: Configure SDDM Symlink
    SDDM_THEME_DIR="/usr/share/sddm/themes/sddm-hyprland-setup"
    if [ -d "$SDDM_THEME_DIR" ]; then
      log_step "Linking SDDM background to Pywal cache..."

      (setup_sddm_symlink) > /dev/null 2>&1 &
      spin $!

      if [ $? -eq 0 ]; then
        log_success "SDDM background successfully linked to Pywal wallpaper."
      else
        log_error "Failed to set up SDDM background symlink."
      fi
    fi
  else
    log_error "Failed to install Pywal Theme Switcher."
  fi

  rm -rf "$THEME_SWITCHER_DIR"
fi
