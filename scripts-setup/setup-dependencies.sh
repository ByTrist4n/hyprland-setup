#!/bin/bash
# =============================================================
#  Base Dependencies Installation
# =============================================================
set -e
source "./utils.sh"

# Pacman packages
log_step "Installing core and basic packages via Pacman..."
sudo pacman -S --needed --noconfirm \
    nvim yay fish brightnessctl pavucontrol blueman \
    ttf-jetbrains-mono-nerd \
    wl-clipboard hyprlock hypridle \
    qt5ct qt6ct cliphist sed rofi flameshot yazi

# Yay packages
log_step "Installing AUR packages..."
yay -S --needed --noconfirm \
    waybar wlogout swaync \
    dolphin \
    vscodium-bin zen-browser pear-desktop logiops \
    awww python-pywal16 wpgtk nwg-look papirus-icon-theme kvantum \

echo ""
echo "🎉 Dependencies Setup complete!"
echo ""