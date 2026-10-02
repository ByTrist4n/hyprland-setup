#!/bin/bash
# =============================================================
#  Pywal Theme Switcher Installation (Dynamic Colors Integration)
# =============================================================
set -e
source "./utils.sh"

LOG_FILE="${LOG_FILE:-/tmp/hyprland-setup-install.log}"

setup_sddm_integration() {
  local hooks_dir="$HOME/.config/pywal-theme-switcher/post-hooks.d"
  local hook_script="$hooks_dir/sddm-update.sh"

  mkdir -p "$hooks_dir" >> "$LOG_FILE" 2>&1

  # Create post-hook script to update SDDM wallpaper on theme change
  cat << 'EOF' > "$hook_script"
#!/bin/bash
sddm_target="/var/tmp/sddm_wallpaper.jpg"
wal_wallpaper="$HOME/.cache/wal/wal_wallpaper.jpg"

if [ -f "$wal_wallpaper" ]; then
  cp -f "$wal_wallpaper" "$sddm_target"
  chmod 644 "$sddm_target"
fi
EOF

  chmod +x "$hook_script" >> "$LOG_FILE" 2>&1

  # Run hook once immediately
  "$hook_script" >> "$LOG_FILE" 2>&1 || true
}

setup_kitty_integration() {
  local kitty_conf_dir="$HOME/.config/kitty"
  local kitty_conf_file="$kitty_conf_dir/kitty.conf"
  local wal_cache_dir="$HOME/.cache/wal"
  local kitty_colors_file="$wal_cache_dir/colors-kitty.conf"
  local include_line="include ~/.cache/wal/colors-kitty.conf"

  # 1. Ensure .cache/wal directory exists and colors-kitty.conf exists
  mkdir -p "$wal_cache_dir" >> "$LOG_FILE" 2>&1
  if [ ! -f "$kitty_colors_file" ]; then
    touch "$kitty_colors_file" >> "$LOG_FILE" 2>&1
  fi
  chown "$USER:$USER" "$kitty_colors_file" >> "$LOG_FILE" 2>&1 || true

  # 2. Append include directive to kitty.conf if missing
  mkdir -p "$kitty_conf_dir" >> "$LOG_FILE" 2>&1
  if [ ! -f "$kitty_conf_file" ]; then
    touch "$kitty_conf_file" >> "$LOG_FILE" 2>&1
  fi

  if ! grep -qF "$include_line" "$kitty_conf_file"; then
    echo "" >> "$kitty_conf_file"
    echo "# Include dynamic Pywal color palette" >> "$kitty_conf_file"
    echo "$include_line" >> "$kitty_conf_file"
  fi
}

setup_wlogout_integration() {
  local wlogout_conf_dir="$HOME/.config/wlogout"
  local hooks_dir="$HOME/.config/pywal-theme-switcher/post-hooks.d"
  local hook_script="$hooks_dir/wlogout-update.sh"

  if [ -d "$wlogout_conf_dir" ]; then
    mkdir -p "$hooks_dir" >> "$LOG_FILE" 2>&1

    # Create post-hook for wlogout to recolor SVG fill attributes
    cat << 'EOF' > "$hook_script"
#!/bin/bash
# Recolor wlogout SVG icons using Pywal palette

wal_colors="$HOME/.cache/wal/colors.json"
wlogout_assets="$HOME/.config/wlogout/assets"

if [ -f "$wal_colors" ] && [ -d "$wlogout_assets" ]; then
  color_wal=$(grep -oP '"color15":\s*"\K[^"]+' "$wal_colors")

  if [ -n "$color_wal" ]; then
    find "$wlogout_assets" -type f -name "*.svg" -exec sed -i -E "s/fill=\"[^\"]*\"/fill=\"$color_wal\"/g" {} +
  fi
fi

if pgrep -x "wlogout" > /dev/null; then
  pkill -HUP wlogout 2>/dev/null || true
fi
EOF

    chmod +x "$hook_script" >> "$LOG_FILE" 2>&1

    # Execute hook immediately once
    "$hook_script" >> "$LOG_FILE" 2>&1 || true
  fi
}

setup_dolphin_integration() {
  local dolphin_conf_dir="$HOME/.config"
  local dolphin_conf_file="$dolphin_conf_dir/dolphinrc"

  mkdir -p "$dolphin_conf_dir" >> "$LOG_FILE" 2>&1

  if [ ! -f "$dolphin_conf_file" ]; then
    # Create file with default UiSettings section if missing
    cat << 'EOF' > "$dolphin_conf_file"
[UiSettings]
ColorScheme=Pywal
EOF
  else
    # File exists: check if [UiSettings] header is present
    if grep -q "^\[UiSettings\]" "$dolphin_conf_file"; then
      # Update or add ColorScheme key within [UiSettings]
      if grep -q "^ColorScheme=" "$dolphin_conf_file"; then
        sed -i 's/^ColorScheme=.*/ColorScheme=Pywal/' "$dolphin_conf_file" >> "$LOG_FILE" 2>&1
      else
        sed -i '/^\[UiSettings\]/a ColorScheme=Pywal' "$dolphin_conf_file" >> "$LOG_FILE" 2>&1
      fi
    else
      # Append new section if [UiSettings] doesn't exist
      echo "" >> "$dolphin_conf_file"
      echo "[UiSettings]" >> "$dolphin_conf_file"
      echo "ColorScheme=Pywal" >> "$dolphin_conf_file"
    fi
  fi
}

log_section "Setting up Pywal Theme Switcher..."
log_step "Installing \"Pywal Theme Switcher\"..."
log_info "Pywal Theme Switcher dynamically themes Hyprland, GTK, Qt & Quickshell."
log_info "Repo: https://github.com/ByTrist4n/pywal-theme-switcher"

REPO_URL="https://github.com/ByTrist4n/pywal-theme-switcher.git"
THEME_SWITCHER_DIR="$(mktemp -d)"

# Step 1: Install Pywal Theme Switcher
if git clone --quiet --depth 1 "$REPO_URL" "$THEME_SWITCHER_DIR"; then
  # Run installation with --rofi and -y (non-interactive mode)
  if (cd "$THEME_SWITCHER_DIR" && ./install.sh --rofi -y >> "$LOG_FILE" 2>&1); then
    log_success "Pywal Theme Switcher has been successfully configured."
  else
    log_error "Failed to install Pywal Theme Switcher. Check $LOG_FILE"
    rm -rf "$THEME_SWITCHER_DIR"
    exit 1
  fi
else
  log_error "Failed to clone Pywal Theme Switcher repository."
  rm -rf "$THEME_SWITCHER_DIR"
  exit 1
fi

rm -rf "$THEME_SWITCHER_DIR"

# Step 2: Configure Kitty integration
log_step "Configuring Kitty color integration..."
setup_kitty_integration

# Step 3: Configure Dolphin integration
log_step "Configuring Dolphin color scheme..."
setup_dolphin_integration

# Step 4: Configure SDDM integration hook
SDDM_THEME_DIR="/usr/share/sddm/themes/sddm-hyprland-setup"
if [ -d "$SDDM_THEME_DIR" ]; then
  log_step "Configuring SDDM wallpaper sync hook..."
  setup_sddm_integration
  log_success "SDDM wallpaper hook successfully set up."
fi

# Step 5: Configure wlogout integration hook
WLOGOUT_CONF_DIR="$HOME/.config/wlogout"
if [ -d "$WLOGOUT_CONF_DIR" ]; then
  log_step "Configuring wlogout color sync hook..."
  setup_wlogout_integration
  log_success "wlogout hook successfully set up."
fi
