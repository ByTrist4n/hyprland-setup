#!/bin/bash
# =============================================================
#  Base Dependencies Installation
# =============================================================
set -e
source "./utils.sh"

sudo -v

# Refresh mirrors and databases
log_step "Updating Pacman database..."
(sudo pacman -Sy --noconfirm > /dev/null 2>&1) &
spin $!
log_success "Pacman database updated!"

# Pacman packages
log_step "Installing core and basic packages via Pacman..."
(sudo pacman -S --needed --noconfirm \
    hyprland sddm kitty zsh nvim yay brightnessctl pavucontrol blueman \
    ttf-jetbrains-mono-nerd \
    wl-clipboard hyprlock hypridle \
    wf-recorder slurp \
    qt5ct qt6ct cliphist rofi flameshot yazi \
    archlinux-xdg-menu \
    fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool \
    zip \
    libreoffice-still \
    dolphin nm-connection-editor \
    papirus-icon-theme kvantum cava \
    quickshell > /dev/null 2>&1) &

spin $!
log_success "Pacman packages installed successfully!"

# Yay packages (AUR Repositories)
log_step "Installing AUR packages..."
(yay -S --needed --noconfirm \
    wlogout \
    vscodium-bin zen-browser pear-desktop logiops \
    awww pywal-16-git wpgtk nwg-look \
    rofimoji ydotool > /dev/null 2>&1) &

spin $!
log_success "AUR packages installed successfully!"

log_success "Dependencies Setup complete!"
