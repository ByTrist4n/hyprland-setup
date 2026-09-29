#!/bin/bash
# Success message displayed inside Kitty on first Hyprland launch

source "./utils.sh"

LOG_FILE="${LOG_FILE:-/tmp/hyprland-setup-install.log}"

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
echo -e "  ${GREEN}${ICON_SUCCESS} Well done! You now have a great Hyprland setup! ${ICON_FLEX}${NC}"
echo ""
echo -e "  ${GREEN}If you use \"Pywal Theme Swicther\", we recommend running"
echo -e "  '${CYAN}pywal-theme-switcher${GREEN}' or pressing '${YELLOW}SUPER + SHIFT + T${GREEN}'"
echo -e "  to select a theme.${NC}"
echo ""
echo -e "  ${YELLOW}${ICON_STAR} If you like it, drop a star! It helps a lot ${ICON_LOVE}${NC}"
echo -e "  ${CYAN}${ICON_PACKAGE} Repository:${NC} $(
  print_link "${REPO_URL}" "${REPO_URL}" "${BLUE}${BOLD}"
)"
echo ""
echo -e "  Having trouble? Run the troubleshooting script to fix issues:"
echo -e "     ${ICON_ARROW} sh troubleshooting.sh"
echo -e "     ${ICON_ARROW} https://github.com/ByTrist4n/hyprland-setup/issues"
echo ""
echo -e "${MAGENTA}────────────────────────────────────────────────────────────────────────${NC}"

# Remove the temporary hl.exec_cmd line from hyprland.lua
if [ -f "$HOME/.config/hypr/hyprland.lua" ]; then
  sed -i '/welcome.sh/d' "$HOME/.config/hypr/hyprland.lua" >> "$LOG_FILE" 2>&1 || true
fi

read -p "Press [ENTER] to close this window..."
