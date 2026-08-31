#!/bin/bash
# =============================================================
#  Main Installation Script for Hyprland Setup
# =============================================================
set -e
source "./utils.sh"

echo "                         _                 _   __      _               ";
echo "  /\\  /\\_   _ _ __  _ __| | __ _ _ __   __| | / _\\ ___| |_ _   _ _ __  ";
echo " / /_/ / | | | '_ \\| '__| |/ _\` | '_ \\ / _\` | \\ \\ / _ \\ __| | | | '_ \\ ";
echo "/ __  /| |_| | |_) | |  | | (_| | | | | (_| | _\\ \\  __/ |_| |_| | |_) |";
echo "\\/ /_/  \\__, | .__/|_|  |_|\\__,_|_| |_|\\__,_| \\__/\\___|\\__|\\__,_| .__/ ";
echo "        |___/|_|                                                |_|    ";
echo -e "   ${BOLD}✨ Installation Script for the Hyprland of your Dreams ${NC}• ${BLUE}By '\e]8;;https://github.com/ByTrist4n/\e\\ByTrist4n\e]8;;\e\\'${NC}"
echo -e "────────────────────────────────────────────────────────────────────────"
echo ""

# -------------------------------------------------------------
# Safety Check Prompt
# -------------------------------------------------------------
echo -e "┌──────┤ WARNING ├─────────────────────────────────────────────────────┐"
echo -e "│ Before beginning the installation, please back up your system.       │"
echo -e "│ You use this programme entirely at your own risk.                    │"
echo -e "└──────────────────────────────────────────────────────────────────────┘"
echo ""

if ask_yes_no "Would you like to continue with the installation?"; then
    source "./scripts/setup-dependencies.sh"
    source "./scripts/setup-oh-my-zsh.sh"

    # -------------------------------------------------------------
    # Clone and Deploy Hyprland Dotfiles (Configuration folders)
    # -------------------------------------------------------------
    log_step "Deploying Hyprland configuration files..."

    DOTFILES_URL="https://github.com/TristanDefachel/hyprland-dot-files.git"
    DOTFILES_DIR="$(mktemp -d)"

    if git clone --depth 1 "$DOTFILES_URL" "$DOTFILES_DIR" >/dev/null 2>&1; then
        mkdir -p "$HOME/.config"

        # Copy all configuration folders directly to ~/.config/
        # Exclude git metadata
        rsync -av --exclude='.git' --exclude='.gitignore' --exlude='README.md' "$DOTFILES_DIR/" "$HOME/.config/" >/dev/null 2>&1 \
            || cp -rf "$DOTFILES_DIR"/* "$HOME/.config/"

        # Symlink .zshrc from ~/.config/zsh/.zshrc to $HOME/.zshrc
        if [ -f "$HOME/.config/zsh/.zshrc" ]; then
            log_info "Linking .zshrc to home directory..."
            ln -sf "$HOME/.config/zsh/.zshrc" "$HOME/.zshrc"
        fi

        # Reload Hyprland configuration if running
        if command -v hyprctl &> /dev/null; then
            hyprctl reload
        fi

        log_success "Dotfiles have been successfully deployed."
    else
        log_error "Failed to clone $DOTFILES_URL."
    fi

    rm -rf "$DOTFILES_DIR"

    source "./scripts/setup-lazyvim.sh"
	source "./scripts/setup-theme-sw1tcher.sh"

    # -------------------------------------------------------------
    # Success Screen
    # -------------------------------------------------------------
    echo ""
    echo -e "${CYAN}────────────────────────────────────────────────────────────────────────${NC}"
    echo -e "  ${GREEN}🎉 Well done 💪 You now have a great Hyprland setup!${NC}"
    echo -e "  🤔 Having trouble?${NC} Run the troubleshooting script to fix issues:"
    echo -e "     ➔ ${BLUE}${BOLD}sh troubleshooting.sh${NC}"
    echo -e "${CYAN}────────────────────────────────────────────────────────────────────────${NC}"
    echo ""
fi