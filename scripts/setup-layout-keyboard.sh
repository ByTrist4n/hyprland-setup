#!/bin/bash
# =============================================================
#  Configure Hyprland Keyboard Layout
# =============================================================

set -e
source "./utils.sh"

log_info "Configuring keyboard layout for Hyprland..."

if ask_yes_no "Would you like to configure the keyboard layout?"; then
  echo ""
  echo -e "  ${BOLD}1)${NC} US Standard (us / basic) [DEFAULT]"
  echo -e "  ${BOLD}2)${NC} US International (us / intl)"
  echo -e "  ${BOLD}3)${NC} French Standard (fr / azerty)"

  choice=$(ask_choice "Choose your layout" 3)

  input_lua_file="$HOME/.config/hypr/config/inputs.lua"

  case "$choice" in
    1)
      log_info "Skipping keyboard auto-configuration."
      ;;
    2)
      layout="us"
      variant="intl"
      ;;
    3)
      layout="fr"
      variant=""
      ;;

  esac

  if [[ "$choice" != "1" && -f "$input_lua_file" ]]; then
    sed -i "s/kb_layout = \".*\"/kb_layout = \"$layout\"/" "$input_lua_file"
    sed -i "s/kb_variant = \".*\"/kb_variant = \"$variant\"/" "$input_lua_file"

    log_success "Keyboard layout set to '$layout' (variant: '$variant')."
  elif [[ "$choice" != "1" ]]; then
    log_warning "File $input_lua_file not found. Make sure dotfiles are copied first."
  fi
else
  log_info "Skipping keyboard auto-configuration."
fi
