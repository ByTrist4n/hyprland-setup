#!/bin/bash
# Success message displayed inside Kitty on first Hyprland launch

source "./utils.sh" 2> /dev/null || true

clear

echo -e "${CYAN}────────────────────────────────────────────────────────────────────────${NC}"
echo -e "  ${GREEN}${ICON_SUCCESS} Well done! You now have a great Hyprland setup! ${ICON_FLEX}${NC}"
echo ""
echo -e "  ${YELLOW}${ICON_STAR} If you like it, drop a star! It helps a lot ${ICON_LOVE}${NC}"
echo -e "  ${CYAN}${ICON_PACKAGE} Repository:${NC} $(
  print_link "${REPO_URL}" "${REPO_URL}" "${BLUE}${BOLD}"
)"
echo ""
echo -e "  ${GREEN}We recommend running '${CYAN}pywal-theme-switcher${GREEN}' or"
echo -e "  pressing '${YELLOW}SUPER + SHIFT + T${GREEN}' to select a theme.${NC}"
echo ""
echo -e " Having trouble? Run the troubleshooting script to fix issues:"
echo -e "     ${ICON_ARROW} sh troubleshooting.sh"
echo -e "     ${ICON_ARROW} https://github.com/ByTrist4n/hyprland-setup/issues"
echo ""
echo -e "${CYAN}────────────────────────────────────────────────────────────────────────${NC}"

# Remove the temporary hl.exec_cmd line from hyprland.lua
sed -i '/welcome.sh/d' "$HOME/.config/hypr/hyprland.lua" 2> /dev/null || true

read -p "Press [ENTER] to close this window..."
