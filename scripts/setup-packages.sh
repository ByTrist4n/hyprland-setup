#!/bin/bash
# =============================================================
#  Base Dependencies Installation
# =============================================================
set -e
source "./utils.sh"

LOG_FILE="${LOG_FILE:-/tmp/hyprland-setup-install.log}"

# -------------------------------------------------------------
# Phase 1: Core System Dependencies
# -------------------------------------------------------------
export STEP_TOTAL_MANUAL=3

# Core System Packages (Official Repos)
CORE_PACMAN=(
  archlinux-xdg-menu
  base-devel
  blueman
  brightnessctl
  cava
  cliphist
  dolphin
  fastfetch
  fcitx5
  fcitx5-configtool
  fcitx5-gtk
  fcitx5-qt
  git
  grim
  hypridle
  hyprland
  hyprlock
  imagemagick
  inetutils
  kitty
  libavif
  libheif
  lib32-mesa
  lib32-vulkan-icd-loader
  mesa
  nm-connection-editor
  noto-fonts-emoji
  nvim
  papirus-icon-theme
  pavucontrol
  quickshell
  satty
  sddm
  slurp
  ttf-jetbrains-mono-nerd
  vim
  vulkan-icd-loader
  virglrenderer
  wf-recorder
  wl-clipboard
  zip
  zsh
)

# Core AUR Packages
CORE_AUR=(
  elephant
  elephant-desktopapplications
  elephant-calc
  elephant-clipboard
  elephant-symbols
  elephant-files
  walker
  wlogout
)

# Extra Optional Packages (Official Repos)
EXTRA_PACMAN=(
  libreoffice-still
  vlc
  yazi
)

# Extra Optional Packages (AUR)
EXTRA_AUR=(
  logiops
  vscodium-bin
  zen-browser-bin
)

# Generic function to execute package installation cleanly
install_pkgs() {
  local installer="$1"
  local label="$2"
  shift 2
  local pkgs=("$@")

  log_step "Installing ${label} packages (${#pkgs[@]} packages)..."

  local cmd=()
  if [ "$installer" = "pacman" ]; then
    cmd=(sudo pacman -S --needed --noconfirm)
  else
    cmd=("$installer" -S --needed --noconfirm)
  fi

  "${cmd[@]}" "${pkgs[@]}" >> "$LOG_FILE" 2>&1 &
  local cmd_pid=$!
  spin "$cmd_pid"

  if wait "$cmd_pid"; then
    log_success "${label} packages installed successfully!"
  else
    log_error "Failed to install ${label} packages!"
    log_info "Check the error details in: ${LOG_FILE}"
    exit 1
  fi
}

# Ensure yay is present (bootstrap from AUR if missing)
ensure_aur_helper() {
  if ! command -v yay &> /dev/null; then
    log_info "AUR helper (yay) not found. Bootstrapping yay..."

    sudo pacman -S --needed --noconfirm git base-devel >> "$LOG_FILE" 2>&1

    local tmp_dir
    tmp_dir=$(mktemp -d)

    (git clone https://aur.archlinux.org/yay.git "$tmp_dir/yay" >> "$LOG_FILE" 2>&1 \
      && cd "$tmp_dir/yay" \
      && makepkg -s --noconfirm >> "$LOG_FILE" 2>&1 \
      && sudo pacman -U --noconfirm yay-*.pkg.tar.zst >> "$LOG_FILE" 2>&1) &

    local cmd_pid=$!
    spin "$cmd_pid"

    if wait "$cmd_pid"; then
      rm -rf "$tmp_dir"
      log_success "yay successfully bootstrapped!"
    else
      rm -rf "$tmp_dir"
      log_error "Failed to bootstrap yay. Check logs at $LOG_FILE"
      exit 1
    fi
  fi
}

# Enable multilib repository if not already active (required for lib32-* packages)
ensure_multilib() {
  if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    log_info "Enabling multilib repository in /etc/pacman.conf..."
    echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf > /dev/null
  fi
}

# Run core steps [1/3] to [3/3]
ensure_multilib

log_step "Updating Pacman database..."
sudo pacman -Syu --noconfirm >> "$LOG_FILE" 2>&1 &
spin $!

if wait $!; then
  log_success "Pacman database updated!"
else
  log_error "Failed to update Pacman database. Check logs at $LOG_FILE"
  exit 1
fi

install_pkgs "pacman" "Core System" "${CORE_PACMAN[@]}"
ensure_aur_helper
install_pkgs "yay" "Core AUR" "${CORE_AUR[@]}"

# -------------------------------------------------------------
# Phase 2: Optional Extra Applications
# -------------------------------------------------------------
echo ""
echo -e "${BLUE}Optional extra applications list:${NC}"
echo -e "  • ${CYAN}libreoffice-still${NC} - Office suite"
echo -e "  • ${CYAN}logiops${NC}           - Logitech MX app"
echo -e "  • ${CYAN}vlc${NC}               - VLC media player"
echo -e "  • ${CYAN}vscodium-bin${NC}      - Open-source Code Editor"
echo -e "  • ${CYAN}yazi${NC}              - Terminal file manager"
echo -e "  • ${CYAN}zen-browser-bin${NC}   - Best Web Browser (Firefox core)"
echo ""

if ask_yes_no "Would you like to install these extra applications?"; then
  # Reset file tracking so log_step recalculates a fresh stepper [1/2]
  unset LAST_FILE
  export STEP_TOTAL_MANUAL=2

  log_section "Installing Optional Extra Applications"
  install_pkgs "pacman" "Extra Official" "${EXTRA_PACMAN[@]}"
  install_pkgs "yay" "Extra AUR" "${EXTRA_AUR[@]}"
fi

log_success "Dependencies Setup complete!"
