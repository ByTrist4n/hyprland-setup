#!/bin/bash
# =============================================================
# A simplified, automated configuration script that allows you to create a polished,
# functional Hyprland environment with a single command.
# Repository: https://github.com/ByTrist4n/hyprland-setup
# Author: ByTrist4n (https://github.com/ByTrist4n)
# ==============================================================================

set -e
source "./utils.sh"

clear

echo -e "${MAGENTA}──────────────────────────────────────────────────────────────────────${NC}"
echo -e "${CYAN}"
echo "  ██╗  ██╗██╗   ██╗██████╗ ██████╗ ██╗      █████╗ ███╗   ██╗██████╗  "
echo "  ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██║     ██╔══██╗████╗  ██║██╔══██╗ "
echo "  ███████║ ╚████╔╝ ██████╔╝██████╔╝██║     ███████║██╔██╗ ██║██║  ██║ "
echo "  ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██╔══██║██║╚██╗██║██║  ██║ "
echo "  ██║  ██║   ██║   ██║     ██║  ██║███████╗██║  ██║██║ ╚████║██████╔╝ "
echo "  ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝  "
echo -e "${NC}"
echo -e "                         ${MAGENTA}S E T U P${NC}"
echo ""
echo -e "${MAGENTA}──────────────────────────────────────────────────────────────────────${NC}"
echo ""
type_text 0.03 "" "  ${ICON_SPARKLE} Installation sript for the Hyprland of your dreams • By "
print_link "${PROFIL_URL}" "ByTrist4n" "${BLUE}${BOLD}"
echo ""
echo ""
echo -e "  ${YELLOW}${ICON_STAR} If you like it, drop a star! It helps a lot ${ICON_LOVE}${NC}"
echo -e "  ${CYAN}${ICON_PACKAGE} Repository:${NC} $(
  print_link "${REPO_URL}" "${REPO_URL}" "${BLUE}${BOLD}"
)"
echo ""

echo -e "${YELLOW}┌──────┤ WARNING ├─────────────────────────────────────────────────────┐${NC}"
echo -e "${YELLOW}│${NC} Before beginning the installation, please back up your system.       ${YELLOW}│${NC}"
echo -e "${YELLOW}│${NC} For your information, the script backs up \"~/.config/\" and \".zshrc\". ${YELLOW}│${NC}"
echo -e "${YELLOW}│${NC}                                                                      ${YELLOW}│${NC}"
echo -e "${YELLOW}│${NC} You use this programme entirely at your own risk.                    ${YELLOW}│${NC}"
echo -e "${YELLOW}└──────────────────────────────────────────────────────────────────────┘${NC}"
echo ""

# Check if running on Arch Linux or arch-based distro
if [ -f /etc/os-release ]; then
  . /etc/os-release
  if [[ "$ID" != "arch" && "$ID_LIKE" != *"arch"* ]]; then
    log_error "This script is designed for Arch Linux and its derivatives only."
    exit 1
  fi
else
  log_error "This script is designed for Arch Linux and its derivatives only.\n     Cannot detect OS distribution (/etc/os-release missing)."
  exit 1
fi

if ask_yes_no "Right, let's go!"; then

  bash "./scripts/backup.sh"
  bash "./scripts/setup-packages.sh"
  bash "./scripts/setup-oh-my-zsh.sh"

  bash "./scripts/setup-config.sh"
  bash "./scripts/setup-layout-keyboard.sh"
  bash "./scripts/setup-sddm.sh"
  bash "./scripts/setup-lazyvim.sh"
  bash "./scripts/setup-pywal-theme-switcher.sh"

  # Check if Hyprland is currently running
  if pgrep -x "Hyprland" > /dev/null 2>&1; then
    log_info "Hyprland is already running."

    # Reload config without injecting duplicate exec commands
    hyprctl reload
    log_success "Configuration reloaded!"

    # Launch Kitty welcome screen directly once
    kitty --title 'Welcome' -e "$PWD/scripts/welcome.sh" &
  else
    # Hyprland is NOT running: inject command for first graphical launch
    if [ -f "$HOME/.config/hypr/hyprland.lua" ]; then
      sed -i '/welcome.sh/d' "$HOME/.config/hypr/hyprland.lua" 2> /dev/null || true
      echo -e "\nhl.exec_cmd(\"kitty --title 'Welcome' -e $PWD/scripts/welcome.sh\")" >> "$HOME/.config/hypr/hyprland.lua"
    fi

    echo -en "${GREEN}Launching Hyprland in ${NC}"
    for i in 3 2 1; do
      echo -n "$i... "
      sleep 1
    done
    echo ""
    exec Hyprland
  fi
fi
