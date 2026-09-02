#!/bin/bash
# =============================================================
#  Theme Sw1tcher Installation (Dynamic Colors Integration)
# =============================================================

set -e
source "./utils.sh"

if ask_yes_no "Would you like to set up Theme Sw1tcher (https://github.com/ByTrist4n/theme-sw1tcher)?"; then
    log_step "Setting up Theme Sw1tcher..."

    REPO_URL="https://github.com/ByTrist4n/theme-sw1tcher.git"
    THEME_SWITCHER_DIR="$(mktemp -d)"

    (
        if git clone --quiet --depth 1 "$REPO_URL" "$THEME_SWITCHER_DIR"; then
            cd "$THEME_SWITCHER_DIR" && ./install.sh
        else
            exit 1
        fi
    ) >/dev/null 2>&1 &

    spin $!

    # Check exit status of the subshell process
    if [ $? -eq 0 ]; then
        log_success "Theme Sw1tcher has been successfully configured."
    else
        log_error "Failed to install Theme Sw1tcher."
    fi

    rm -rf "$THEME_SWITCHER_DIR"
fi
