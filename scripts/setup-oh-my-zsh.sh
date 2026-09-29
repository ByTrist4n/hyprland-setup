#!/bin/bash
# =============================================================
#  Oh My Zsh Core & Plugins Setup
# =============================================================
set -e
source "./utils.sh"

LOG_FILE="${LOG_FILE:-/tmp/hyprland-setup-install.log}"
# Define custom directory for Zsh user plugins and themes (XDG compliant)
ZSH_CUSTOM="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/custom"

if ask_yes_no "Would you like to install Oh My Zsh, plugins, and CLI tools (fzf, zoxide, atuin)?"; then
  # Install Oh My Zsh core
  log_step "Installing Oh My Zsh Core..."
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    (RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" >> "$LOG_FILE" 2>&1) &
    spin $!

    if wait $!; then
      log_success "Oh My Zsh core installed."
    else
      log_error "Failed to install Oh My Zsh. Check $LOG_FILE"
      exit 1
    fi
  else
    log_info "Oh My Zsh is already installed."
  fi

  # Install CLI tools
  log_step "Installing CLI helper tools (fzf, zoxide, atuin...)"
  (sudo pacman -S --needed --noconfirm fzf zoxide atuin eza >> "$LOG_FILE" 2>&1) &
  spin $!

  if wait $!; then
    log_success "CLI tools installed."
  else
    log_error "Failed to install CLI tools. Check $LOG_FILE"
    exit 1
  fi

  # Setup Zsh plugins and themes
  log_step "Installing Zsh plugins and themes..."
  mkdir -p "$ZSH_CUSTOM/plugins" "$ZSH_CUSTOM/themes"

  (
    # Clone zsh-autosuggestions
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
      git clone --quiet https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    fi

    # Clone zsh-syntax-highlighting
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
      git clone --quiet https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    fi

    # Clone Headline theme
    if [ ! -d "$ZSH_CUSTOM/themes/headline" ]; then
      git clone --quiet https://github.com/moarram/headline.git "$ZSH_CUSTOM/themes/headline"
    fi
  ) >> "$LOG_FILE" 2>&1 &

  spin $!

  if wait $!; then
    log_success "Zsh plugins and themes successfully installed in $ZSH_CUSTOM"
  else
    log_error "Failed to clone Zsh plugins or themes. Check $LOG_FILE"
    exit 1
  fi
fi
