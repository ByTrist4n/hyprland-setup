#!/bin/bash
# =============================================================
#  Pywal Theme Switcher Installation (Dynamic Colors Integration)
# =============================================================

set -e
source "./utils.sh"

if ask_yes_no "Would you like to set up \"Pywal Theme Switcher\" (https://github.com/ByTrist4n/pywal-theme-switcher)?"; then
  log_step "Setting up Pywal Theme Switcher..."

  REPO_URL="https://github.com/ByTrist4n/pywal-theme-switcher.git"
  THEME_SWITCHER_DIR="$(mktemp -d)"

  (
    if git clone --quiet --depth 1 "$REPO_URL" "$THEME_SWITCHER_DIR"; then
      cd "$THEME_SWITCHER_DIR" && ./install.sh
    else
      exit 1
    fi
  ) > /dev/null 2>&1 &

  spin $!

  # Check exit status of the subshell process
  if [ $? -eq 0 ]; then
    log_success "Pywal Theme Switcher has been successfully configured."
  else
    log_error "Failed to install Pywal Theme Switcher."
  fi

  rm -rf "$THEME_SWITCHER_DIR"
fi
