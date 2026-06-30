#!/bin/bash
# =============================================================
#  Base Dependencies Installation
# =============================================================
set -e
source "./utils.sh"

# Pacman packages
log_step "Installing core and basic packages via Pacman..."
sudo pacman -S --needed --noconfirm \
    zsh nvim yay brightnessctl pavucontrol blueman \
    ttf-jetbrains-mono-nerd \
    wl-clipboard hyprlock hypridle \
    qt5ct qt6ct cliphist sed rofi flameshot yazi

# Yay packages
log_step "Installing AUR packages..."
yay -S --needed --noconfirm \
    wlogout swaync nm-connection-editor \
    dolphin \
    vscodium-bin zen-browser pear-desktop logiops \
    awww python-pywal16 wpgtk nwg-look papirus-icon-theme kvantum \
    libcava

_with_cava=true yay -S --needed --noconfirm waybar-git 

log_step "Install Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    log_success "Oh My Zsh has been installed"
else
    log_info "Oh My Zsh is already installed."
fi

echo ""
echo "🎉 Dependencies Setup complete!"
echo ""