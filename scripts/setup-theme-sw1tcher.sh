 # -------------------------------------------------------------
    # Install Theme Sw1tcher (Dynamic Colors Integration)
    # -------------------------------------------------------------
    if ask_yes_no "Would you like to set up Theme Sw1tcher (https://github.com/ByTrist4n/theme-sw1tcher)?"; then
        log_step "Set up Theme Sw1tcher..."

        REPO_URL="https://github.com/ByTrist4n/theme-sw1tcher.git"
        THEME_SWITCHER_DIR="$(mktemp -d)"

        if git clone --depth 1 "$REPO_URL" "$THEME_SWITCHER_DIR"; then
            (cd "$THEME_SWITCHER_DIR" && ./install.sh) \
                && log_info "Theme Sw1tcher has been successfully configured." \
                || log_error "Theme Sw1tcher install.sh has failed."
        else
            log_error "Failed to clone $REPO_URL."
        fi

        rm -rf "$THEME_SWITCHER_DIR"
    fi
