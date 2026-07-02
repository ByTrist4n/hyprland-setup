#!/bin/bash
echo "                         _                 _   __      _               ";
echo "  /\\  /\\_   _ _ __  _ __| | __ _ _ __   __| | / _\\ ___| |_ _   _ _ __  ";
echo " / /_/ / | | | '_ \\| '__| |/ _\` | '_ \\ / _\` | \\ \\ / _ \\ __| | | | '_ \\ ";
echo "/ __  /| |_| | |_) | |  | | (_| | | | | (_| | _\\ \\  __/ |_| |_| | |_) |";
echo "\\/ /_/  \\__, | .__/|_|  |_|\\__,_|_| |_|\\__,_| \\__/\\___|\\__|\\__,_| .__/ ";
echo "        |___/|_|                                                |_|    ";
echo ""
echo "By Tris4n"

source "./utils.sh"

if ask_yes_no "Before beginning the installation, back up your system. Use of this program is at your own risk.\nWould you like to continue with the installation?"; then
    source "./scripts/setup-dependencies.sh"

    # -------------------------------------------------------------
    # Clone and Deploy Hyprland Dotfiles (Configuration folders)
    # -------------------------------------------------------------
    log_step "Deploying Hyprland configuration files..."

    DOTFILES_URL="https://github.com/TristanDefachel/hyprland-dot-files.git"
    DOTFILES_DIR="$(mktemp -d)"
    dir_hypr="$HOME/.config/hypr"

    if git clone --depth 1 "$DOTFILES_URL" "$DOTFILES_DIR"; then
        mkdir -p "$HOME/.config"
        
        log_info "Copying configuration folders to ~/.config/..."
        
        # Loop through the repository root to copy only directories, skipping files like README.md or .gitignore
        for item in "$DOTFILES_DIR"/*; do
            if [ -d "$item" ]; then
                cp -r "$item" "$HOME/.config/"
            fi
        done
        hyprctl reload

        log_success "Dotfiles have been successfully deployed."
    else
        log_error "Failed to clone $DOTFILES_URL."
    fi

    rm -rf "$DOTFILES_DIR"

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

    echo ""
    echo ""
    echo "Well done 💪 You now have a great Hyperland setup"
    echo -e "🤔 Having trouble? Use the troubleshooting script to resolve the issue. Run the following command: ${BLUE}${BOLD}sh troubleshooting.sh${NC}"
fi 