#!/bin/bash
# =============================================================
#  Base Dependencies Installation
# =============================================================
set -e
source "./utils.sh"

STEP_TOTAL_MANUAL=6

LOG_FILE="${LOG_FILE:-/tmp/hyprland-setup-install.log}"

log_step "Request for sudo privileges to install the packages (Pacman, AUR)"

# Keep sudo privileges alive until script finishes
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2> /dev/null &

# Refresh mirrors and databases silently
log_step "Updating Pacman database..."
sudo pacman -Sy --noconfirm >> "$LOG_FILE" 2>&1 &
spin $!

if wait $!; then
  log_success "Pacman database updated!"
else
  log_error "Failed to update Pacman database. Check logs at $LOG_FILE"
  exit 1
fi

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
  inetutils
  kitty
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
  yazi
)

# Extra Optional Packages (AUR)
EXTRA_AUR=(
  logiops
  pear-desktop
  vscodium-bin
  zen-browser-bin
)

# Run core installations
install_pkgs "pacman" "Core System" "${CORE_PACMAN[@]}"
ensure_aur_helper
install_pkgs "yay" "Core AUR" "${CORE_AUR[@]}"

# Extra optional applications
echo ""
echo -e "${BLUE}Optional extra applications list:${NC}"
echo -e "  • ${CYAN}libreoffice-still${NC} - Office suite"
echo -e "  • ${CYAN}yazi${NC}              - Terminal file manager"
echo -e "  • ${CYAN}logiops${NC}           - Logitech MX app"
echo -e "  • ${CYAN}pear-desktop${NC}      - YT music application"
echo -e "  • ${CYAN}vscodium-bin${NC}      - Open-source Code Editor"
echo -e "  • ${CYAN}zen-browser-bin${NC}  - Best Web Browser (Firefox core)"
echo ""

if ask_yes_no "Would you like to install these extra applications?"; then
  install_pkgs "pacman" "Extra Official" "${EXTRA_PACMAN[@]}"
  install_pkgs "yay" "Extra AUR" "${EXTRA_AUR[@]}"
fi

log_success "Dependencies Setup complete!"
