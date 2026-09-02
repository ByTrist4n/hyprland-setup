#!/bin/bash
# =============================================================
#  Base Dependencies Installation
# =============================================================
set -e
source "./utils.sh"

sudo -v

# Refresh mirrors and databases
log_step "Updating Pacman database..."
(sudo pacman -Sy --noconfirm >/dev/null 2>&1) &
spin $!
log_success "Pacman database updated!"

# Core System & Essential Environment Packages (Strictly required for Hyprland Setup)
log_step "Installing core system packages via Pacman..."
(sudo pacman -S --needed --noconfirm \
    archlinux-xdg-menu \
    blueman \
    brightnessctl \
    cava \
    cliphist \
    dolphin \
    fcitx5 \
    fcitx5-configtool \
    fcitx5-gtk \
    fcitx5-qt \
    hyprland \
    hypridle \
    hyprlock \
    kitty \
    kvantum \
    nm-connection-editor \
    nvim \
    papirus-icon-theme \
    pavucontrol \
    qt5ct \
    qt6ct \
    quickshell \
    rofi \
    sddm \
    slurp \
    ttf-jetbrains-mono-nerd \
    wf-recorder \
    wl-clipboard \
    yay \
    zip \
    zsh >/dev/null 2>&1) &

spin $!
log_success "Core system packages installed!"

# Core AUR Packages
log_step "Installing core AUR packages..."
(yay -S --needed --noconfirm \
    awww \
    nwg-look \
    pywal-16-git \
    rofimoji \
    wlogout \
    wpgtk \
    ydotool >/dev/null 2>&1) &

spin $!
log_success "Core AUR packages installed!"

log_step "Extra applications"
echo ""
echo -e "${BLUE}Optional extra applications list:${NC}"
echo -e "  • ${YELLOW}flameshot${NC}         - Advanced screenshot tool"
echo -e "  • ${YELLOW}libreoffice-still${NC} - Office suite"
echo -e "  • ${YELLOW}yazi${NC}              - Terminal file manager"
echo -e "  • ${YELLOW}logiops${NC}           - Logitech MX app"
echo -e "  • ${YELLOW}pear-desktop${NC}      - YT music application"
echo -e "  • ${YELLOW}vscodium-bin${NC}      - Open-source Code Editor"
echo -e "  • ${YELLOW}zen-browser${NC}       - Best Web Browser (Firefox core)"
echo ""
if ask_yes_no "Would you like to install these extra applications?"; then
    log_info "Installing extra Pacman applications..."
    (sudo pacman -S --needed --noconfirm \
        flameshot \
        libreoffice-still \
        yazi >/dev/null 2>&1) &
    spin $!

    log_info "Installing extra AUR applications..."
    (yay -S --needed --noconfirm \
        logiops \
        pear-desktop \
        vscodium-bin \
        zen-browser >/dev/null 2>&1) &
    spin $!

    log_success "Extra applications installed successfully!"
fi

log_success "Dependencies Setup complete!"
