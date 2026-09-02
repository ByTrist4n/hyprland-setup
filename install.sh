#!/bin/bash
set -e
source "./utils.sh"

echo "                         _                 _   __      _               "
echo "  /\\  /\\_   _ _ __  _ __| | __ _ _ __   __| | / _\\ ___| |_ _   _ _ __  "
echo " / /_/ / | | | '_ \\| '__| |/ _\` | '_ \\ / _\` | \\ \\ / _ \\ __| | | | '_ \\ "
echo "/ __  /| |_| | |_) | |  | | (_| | | | | (_| | _\\ \\  __/ |_| |_| | |_) |"
echo "\\/ /_/  \\__, | .__/|_|  |_|\\__,_|_| |_|\\__,_| \\__/\\___|\\__|\\__,_| .__/ "
echo "        |___/|_|                                                |_|    "
echo -e "   ${BOLD}✨ Installation Script for the Hyprland of your Dreams ${NC}• ${BLUE}By '\e]8;;https://github.com/ByTrist4n/\e\\ByTrist4n\e]8;;\e\\'${NC}"
echo -e "────────────────────────────────────────────────────────────────────────"
echo ""
echo -e "┌──────┤ WARNING ├─────────────────────────────────────────────────────┐"
echo -e "│ Before beginning the installation, please back up your system.       │"
echo -e "│ You use this programme entirely at your own risk.                    │"
echo -e "└──────────────────────────────────────────────────────────────────────┘"
echo ""

if ask_yes_no "Would you like to continue with the installation?"; then
    bash "./scripts/setup-dependencies.sh"
    bash "./scripts/setup-oh-my-zsh.sh"

    # -------------------------------------------------------------
    # Clone and Deploy Hyprland Dotfiles (Configuration folders)
    # -------------------------------------------------------------
    log_step "Deploying Hyprland configuration files..."

    DOTFILES_DIR="./config"

    if [ ! -d "$DOTFILES_DIR" ]; then
        log_error "Configuration directory $DOTFILES_DIR not found!"
        exit 1
    fi

    mkdir -p "$HOME/.config"

    # Copy configuration files into ~/.config/ without deleting source files
    cp -rf "$DOTFILES_DIR"/* "$HOME/.config/"

    # Backup existing .zshrc if it exists and is not already a symlink
    if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
        log_info "Backing up existing .zshrc to .zshrc.bak..."
        mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
    fi

    # Symlink .zshrc from ~/.config/zsh/.zshrc to $HOME/.zshrc
    if [ -f "$HOME/.config/zsh/.zshrc" ]; then
        log_info "Linking .zshrc to home directory..."
        ln -sf "$HOME/.config/zsh/.zshrc" "$HOME/.zshrc"
    fi

    # Reload Hyprland configuration if running
    if command -v hyprctl &> /dev/null && [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
        hyprctl reload
    fi

    log_success "Dot files have been successfully deployed."

    bash "./scripts/setup-lazyvim.sh"
    bash "./scripts/setup-theme-sw1tcher.sh"

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
