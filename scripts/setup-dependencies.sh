#!/bin/bash
# =============================================================
#  Base Dependencies Installation
# =============================================================
set -e
source "./utils.sh"

# Refresh mirrors and databases to avoid broken mirror issues
log_step "Updating Pacman database..."
sudo pacman -Sy --noconfirm

# Pacman packages
log_step "Installing core and basic packages via Pacman..."
sudo pacman -S --needed --noconfirm \
    hyprland sddm zsh nvim yay brightnessctl pavucontrol blueman \
    ttf-jetbrains-mono-nerd \
    wl-clipboard hyprlock hypridle \
    wf-recorder slurp \
    qt5ct qt6ct cliphist rofi flameshot yazi \
    archlinux-xdg-menu \
    fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool \
    zip \
    libreoffice-still \
    quickshell
    
# Yay packages
log_step "Installing AUR packages..."
yay -S --needed --noconfirm \
    wlogout nm-connection-editor \
    dolphin \
    vscodium-bin zen-browser pear-desktop logiops \
    awww python-pywal16 wpgtk nwg-look papirus-icon-theme kvantum \
    cava \
    rofimoji ydotool   

log_success "Dependencies Setup complete!"
