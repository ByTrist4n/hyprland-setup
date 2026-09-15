#!/bin/bash
# =============================================================
# A simplified, automated configuration script that allows you to create a polished,
# functional Hyprland environment with a single command.
# Repository: https://github.com/ByTrist4n/hyprland-setup
# Author: ByTrist4n (https://github.com/ByTrist4n)
# ==============================================================================

set -e
source "./utils.sh"

PROFIL_URL="https://github.com/ByTrist4n"
REPO_URL="$PROFIL_URL/hyprland-setup"

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
type_text 0.03 "" "  ✨ Installation Script for the Hyprland of your Dreams • By "
print_link "${PROFIL_URL}" "ByTrist4n" "${BLUE}${BOLD}"
echo ""
echo ""
echo -e "  ${CYAN}📦 Repository:${NC} $(
  print_link "${REPO_URL}" "${REPO_URL}" "${BLUE}${BOLD}"
)"
echo ""
echo -e "  ${YELLOW}⭐ If you like it, drop a star! It helps a lot 🫰💖${NC}"
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

  log_step "Deploying Hyprland configuration files..."

  DOTFILES_DIR="./config"

  if [ ! -d "$DOTFILES_DIR" ]; then
    log_error "Configuration directory $DOTFILES_DIR not found!"
    exit 1
  fi

  mkdir -p "$HOME/.config"

  # Copy configuration files into ~/.config/ without deleting source files
  cp -rf "$DOTFILES_DIR"/* "$HOME/.config/"

  # Symlink .zshrc
  if [ -f "$HOME/.config/zsh/.zshrc" ]; then
    log_info "Linking .zshrc to home directory..."
    ln -sf "$HOME/.config/zsh/.zshrc" "$HOME/.zshrc"
  fi

  log_success "Dot files have been successfully deployed."

  bash "./scripts/setup-sddm.sh"
  bash "./scripts/setup-lazyvim.sh"
  bash "./scripts/setup-pywal-theme-switcher.sh"

  # Reload Hyprland at the very end when all components are installed
  if pgrep -x "Hyprland" > /dev/null 2>&1; then
    log_info "Reloading Hyprland configuration..."
    hyprctl --batch "reload"
    log_success "Hyprland configuration reloaded successfully."
  fi

  # Success screen
  echo ""
  echo -e "${CYAN}────────────────────────────────────────────────────────────────────────${NC}"
  echo -e "  ${GREEN}🎉 Well done 💪 You now have a great Hyprland setup!${NC}"
  echo ""
  echo -e "  🤔 Having trouble? Run the troubleshooting script to fix issues:"
  echo -e "     ➔ ${BLUE}${BOLD}sh troubleshooting.sh${NC}"
  echo -e "     ➔ $(print_link "${REPO_URL}/issues" "Are you having any problems?" "${BLUE}${BOLD}")"
  echo ""
  echo -e "${CYAN}────────────────────────────────────────────────────────────────────────${NC}"
  echo ""
fi
