#!/bin/bash
source "./utils.sh"

echo "                         _                 _   __      _               ";
echo "  /\\  /\\_   _ _ __  _ __| | __ _ _ __   __| | / _\\ ___| |_ _   _ _ __  ";
echo " / /_/ / | | | '_ \\| '__| |/ _\` | '_ \\ / _\` | \\ \\ / _ \\ __| | | | '_ \\ ";
echo "/ __  /| |_| | |_) | |  | | (_| | | | | (_| | _\\ \\  __/ |_| |_| | |_) |";
echo "\\/ /_/  \\__, | .__/|_|  |_|\\__,_|_| |_|\\__,_| \\__/\\___|\\__|\\__,_| .__/ ";
echo "        |___/|_|                                                |_|    ";
echo -e "   ${BOLD}✨ Installation for the Hyprland of dreams ${NC}• ${BLUE}By Trist4n${NC}"
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

    # -------------------------------------------------------------
    # Clone and Deploy Hyprland Dotfiles (Configuration folders)
    # -------------------------------------------------------------
    log_step "Deploying Hyprland configuration files..."

    DOTFILES_URL="https://github.com/TristanDefachel/hyprland-dot-files.git"
    DOTFILES_DIR="$(mktemp -d)"
    dir_hypr="$HOME/.config/hypr"

    if git clone --depth 1 "$DOTFILES_URL" "$DOTFILES_DIR" >/dev/null 2>&1; then
        mkdir -p "$HOME/.config"
        
        log_info "Copying configuration folders..."
        
        # Enable dotglob, see hidden files like .zshrc inside the folders
        shopt -s dotglob

        for item in "$DOTFILES_DIR"/*; do
            if [ -d "$item" ]; then
                # Extract the directory name (e.g., "HOME", "hypr", "waybar")
                dirname=$(basename "$item")

                if [ "$dirname" = "HOME" ] || [ "$dirname" = "\$HOME" ]; then
                    cp -r "$item"/* "$HOME/"
                else
                    cp -r "$item" "$HOME/.config/"
                fi
            fi
        done

        # Disable dotglob
        shopt -u dotglob

        if command -v hyprctl &> /dev/null; then
            hyprctl reload
        fi

        log_success "Dotfiles have been successfully deployed."
    else
        log_error "Failed to clone $DOTFILES_URL."
    fi

    rm -rf "$DOTFILES_DIR"

    # -------------------------------------------------------------
    # Install Theme Sw1tcher (Dynamic Colors Integration)
    # -------------------------------------------------------------
    if ask_yes_no "Would you like to set up a dynamic theme that picks up the current colours from your wallpaper and applies them to all the apps in your Hyprland environment (See https://github.com/TristanDefachel/theme-sw1tcher)?"; then
        log_step "Set up Theme Sw1tcher..."

        REPO_URL="https://github.com/TristanDefachel/theme-sw1tcher.git"
        THEME_SWITCHER_DIR="$(mktemp -d)"

        if git clone --depth 1 "$REPO_URL" "$THEME_SWITCHER_DIR"; then
            (cd "$THEME_SWITCHER_DIR" && ./install.sh) \
                && log_success "Theme Sw1tcher has been successfully configured." \
                || log_error "Theme Sw1tcher install.sh has failed."
        else
            log_error "Failed to clone $REPO_URL."
        fi

        rm -rf "$THEME_SWITCHER_DIR"
    fi

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