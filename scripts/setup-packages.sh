#!/bin/bash
# =============================================================
#  Base Dependencies Installation
# =============================================================
set -e
source "./utils.sh"

STEP_TOTAL_MANUAL=5

log_step "Request for sudo privileges to install the packages (Pacman, AUR)"

# Keep sudo privileges alive until script finishes
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2> /dev/null &

# Refresh mirrors and databases
log_step "Updating Pacman database..."
sudo pacman -Sy --noconfirm
log_success "Pacman database updated!"

# Generic function to execute package installation safely with guided output
install_pkgs() {
  local installer="$1"
  local label="$2"
  local pkgs=("${@:3}")

  log_step "Installing ${label} packages via ${installer}..."

  # Create a temporary log file to catch errors
  local tmp_log
  tmp_log=$(mktemp)

  # Construct command array safely based on the installer name
  local cmd=()
  if [ "$installer" = "pacman" ]; then
    cmd=(sudo pacman -S --needed --noconfirm)
  else
    cmd=("$installer" -S --needed --noconfirm)
  fi

  # Run installation and pipe output to terminal AND log file using array expansion
  "${cmd[@]}" "${pkgs[@]}" 2>&1 | tee "$tmp_log"
  local exit_code=${PIPESTATUS[0]}

  if [ $exit_code -ne 0 ]; then
    log_error "Failed to install required ${label} packages!"

    # Check if the error log mentions conflicting packages
    if grep -iq "conflict" "$tmp_log"; then
      log_warning "A package conflict was detected on your system!"

      # Extract conflicting package names dynamically (strip version numbers)
      local conflicting_pkgs
      conflicting_pkgs=$(grep -i "are in conflict" "$tmp_log" | sed -n 's/.*and \(.*\) are in conflict.*/\1/p' | sed 's/-[0-9].*//' | sort -u)

      if [ -n "$conflicting_pkgs" ]; then
        log_info "To resolve this conflict, try removing the conflicting package(s) manually:"
        for pkg in $conflicting_pkgs; do
          echo -e "  ${YELLOW}sudo pacman -Rdd ${pkg}${NC}"
        done
        echo ""
      else
        log_info "Please check the log above to identify and remove conflicting packages manually."
      fi
    fi

    rm -f "$tmp_log"
    exit 1
  fi

  rm -f "$tmp_log"
  log_success "${label} packages installed!"
}

# Core System Packages (Official Repos)
CORE_PACMAN=(
  archlinux-xdg-menu
  blueman
  brightnessctl
  cava
  cliphist
  dolphin
  fcitx5
  fcitx5-configtool
  fcitx5-gtk
  fcitx5-qt
  grim
  hypridle
  hyprland
  hyprlock
  kitty
  kvantum
  nm-connection-editor
  nvim
  papirus-icon-theme
  pavucontrol
  qt5ct
  qt6ct
  quickshell
  satty
  sddm
  slurp
  ttf-jetbrains-mono-nerd
  wf-recorder
  wl-clipboard
  yay
  zip
  zsh
)

# Core AUR Packages
CORE_AUR=(
  awww
  elephant
  elephant-desktopapplications
  elephant-calc
  elephant-clipboard
  elephant-symbols
  elephant-files
  nwg-look
  pywal-16-git
  walker
  wlogout
  wpgtk
  ydotool
)

# Run core installations
install_pkgs "pacman" "Core System (Pacman)" "${CORE_PACMAN[@]}"
install_pkgs "yay" "Core AUR" "${CORE_AUR[@]}"

# Extra optional applications
log_step "Extra applications"
echo ""
echo -e "${BLUE}Optional extra applications list:${NC}"
echo -e "  • ${YELLOW}libreoffice-still${NC} - Office suite"
echo -e "  • ${YELLOW}yazi${NC}              - Terminal file manager"
echo -e "  • ${YELLOW}logiops${NC}           - Logitech MX app"
echo -e "  • ${YELLOW}pear-desktop${NC}      - YT music application"
echo -e "  • ${YELLOW}vscodium-bin${NC}      - Open-source Code Editor"
echo -e "  • ${YELLOW}zen-browser${NC}       - Best Web Browser (Firefox core)"
echo ""

if ask_yes_no "Would you like to install these extra applications?"; then
  log_info "Installing extra Pacman applications..."
  sudo pacman -S --needed --noconfirm libreoffice-still yazi || log_warning "Some optional Pacman apps failed to install"

  log_info "Installing extra AUR applications..."
  yay -S --needed --noconfirm logiops pear-desktop vscodium-bin zen-browser || log_warning "Some optional AUR apps failed to install"

  log_success "Extra applications process finished!"
fi

log_success "Dependencies Setup complete!"
