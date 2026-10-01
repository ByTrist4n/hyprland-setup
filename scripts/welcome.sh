#!/bin/bash
# Success message displayed inside Kitty on first Hyprland launch

cd "$(dirname "$(readlink -f "$0")")/.." || exit 1
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
echo -e "  ${ICON_SUCCESS} Well done! You now have a great Hyprland setup! ${ICON_FLEX}"
echo ""
echo -e "  If you use \"Pywal Theme Switcher\", we recommend running"
echo -e "  '${CYAN}pywal-theme-switcher${NC}' or pressing '${YELLOW}SUPER + SHIFT + T${NC}'"
echo -e "  to select a theme.${NC}"
echo ""
echo -e "  ${YELLOW}${ICON_STAR} If you like it, drop a star! It helps a lot ${ICON_LOVE}${NC}"
echo -e "  ${ICON_PACKAGE} Repository: $(
  print_link "${REPO_URL}" "${REPO_URL}" "${BLUE}${BOLD}"
)"
echo ""
echo -e "  Having trouble? Run the troubleshooting script to fix issues:"
echo -e "     ${ICON_ARROW} sh troubleshooting.sh"
echo -e "     ${ICON_ARROW} https://github.com/ByTrist4n/hyprland-setup/issues"
echo ""
echo -e "${MAGENTA}────────────────────────────────────────────────────────────────────────${NC}"

# Remove the temporary Welcome line from autostart.lua
if [ -f "$HOME/.config/hypr/config/autostart.lua" ]; then
  sed -i '/welcome.sh/d' "$HOME/.config/hypr/config/autostart.lua" >> "$LOG_FILE" 2>&1 || true
fi

read -p "Press [ENTER] to close this window..."
