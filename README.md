[![Typing SVG](https://readme-typing-svg.demolab.com?font=Sixtyfour&size=24&pause=1000&color=18F71D&width=435&lines=Hyprland+Setup;By+Trist4n)](https://git.io/typing-svg)

[![](https://img.shields.io/github/last-commit/TristanDefachel/hyprland-setup?&style=for-the-badge&labelColor=252733)](https://github.com/TristanDefachel/hyprland-setup)
[![](https://img.shields.io/github/repo-size/TristanDefachel/hyprland-setup?color=%23DDB&label=SIZE&logo=codesandbox&style=for-the-badge&logoColor=D9E0EE&labelColor=252733)](https://github.com/TristanDefachel/hyprland-setup)

# What is it?

Here is a script to configure the Hyprland of dreams ✨

> 🫰 Thank you for the stars ⭐

## Hyprland Setup Showcase

![Screenshot Desktop](./screenshots/screenshot_preview.jpg)

<details>
  <summary><b>✨ Click here to see more screenshots of the Hyprland setup</b></summary>
  <br>

**Information Bar**
![Screenshot Desktop](./screenshots/screenshot_desktop.jpg)
**App Launcher**
![Screenshot Launch](screenshots/screenshot_launch.jpg)
**Notifications center**
![Screenshot notification](screenshots/screenshot_notification.jpg)
**Theme switcher**
![Screenshot Switch theme](screenshots/screenshot_theme_switch.jpg)

</details>

<br>

# Installation

To install, clone the repository and execute the installation script from the root directory:
Bash

```bash
git clone https://github.com/TristanDefachel/hyprland-dot-files.git
cd hyprland-dot-files
sh install.sh
```

# Features

- **Information Bar**
- **App Launcher**
- **Notifications center**
- **Theme Switcher** : Use the colors from the current wallpaper and apply them to all applications in the environment (GTK, Qt, etc)
- **Intuitive keyboard shortcuts** for screenshots, launchers, emoji, Theme switching, and more !

<br>

# 🛠️ Tech Stack

[![Arch Linux](https://img.shields.io/badge/Arch%20Linux-1793D1?logo=arch-linux&logoColor=fff&style=for-the-badge)](https://archlinux.org)
[![Hyprland](https://img.shields.io/badge/Hyprland-blue?style=for-the-badge&logo=hyprland)](https://hypr.land)

### 📦 Core Dependencies (Pacman)

| Package                                                                                                | Description                                        |
| :----------------------------------------------------------------------------------------------------- | :------------------------------------------------- |
| 🐚 [zsh](https://github.com/zsh-users/zsh)                                                             | Advanced shell replacement for Bash                |
| 📝 [nvim](https://github.com/neovim/neovim)                                                            | Vim-based text editor for configuration            |
| 🚀 [yay](https://github.com/Jguer/yay)                                                                 | AUR helper and pacman wrapper                      |
| ☀️ [brightnessctl](https://github.com/Hummer12007/brightnessctl)                                       | Lightweight brightness control utility             |
| 🔊 [pavucontrol](https://gitlab.freedesktop.org/pulseaudio/pavucontrol)                                | PulseAudio/PipeWire volume control GUI             |
| 🔵 [blueman](https://github.com/blueman-project/blueman)                                               | Bluetooth management GTK tool                      |
| 🔤 [ttf-jetbrains-mono-nerd](https://github.com/ryanoasis/nerd-fonts)                                  | Developer font with specialized glyphs and icons   |
| 📋 [wl-clipboard](https://github.com/bugaevc/wl-clipboard)                                             | Command-line copy/paste utilities for Wayland      |
| 🔒 [hyprlock](https://github.com/hyprwm/hyprlock)                                                      | Fast, secure screen locker for Hyprland            |
| 💤 [hypridle](https://github.com/hyprwm/hypridle)                                                      | Idle management daemon for Hyprland                |
| 🎨 [qt5ct](https://sourceforge.net/projects/qt5ct/) / [qt6ct](https://sourceforge.net/projects/qt5ct/) | Qt5 and Qt6 configuration utilities                |
| 📜 [cliphist](https://github.com/Sentriz/cliphist)                                                     | Wayland clipboard manager (text and images)        |
| 🔍 [rofi](https://github.com/davatorium/rofi)                                                          | Window switcher and application launcher           |
| 📸 [flameshot](https://github.com/flameshot-org/flameshot)                                             | Powerful yet simple-to-use screenshot software     |
| 📂 [yazi](https://github.com/sxyazi/yazi)                                                              | Blazing fast terminal file manager written in Rust |

### 🛸 AUR Dependencies (Yay)

| Package                                                                               | Description                                                             |
| :------------------------------------------------------------------------------------ | :---------------------------------------------------------------------- |
| 🚪 [wlogout](https://github.com/ArtsyMacaw/wlogout)                                   | Wayland-based logout menu                                               |
| 🔔 [swaync](https://github.com/ErikReider/SwayNotificationCenter)                     | Sway Notification Center for Wayland                                    |
| 🌐 [nm-connection-editor](https://gitlab.gnome.org/GNOME/network-manager-applet)      | NetworkManager advanced connection editor GUI                           |
| 🐬 [dolphin](https://invent.kde.org/system/dolphin)                                   | KDE file manager                                                        |
| 💻 [vscodium-bin](https://github.com/VSCodium/vscodium)                               | Telemetry-free open-source build of VS Code                             |
| 🧭 [zen-browser](https://github.com/zen-browser/desktop)                              | Firefox-based browser focused on privacy                                |
| 🎵 [pear-desktop](https://github.com/pear-devs/pear-desktop)                          | Music App                                                               |
| 🖱️ [logiops](https://github.com/PixlOne/logiops)                                      | Configuration driver for Logitech mice                                  |
| 🖼️ [awww](https://codeberg.org/LGFae/awww)                                            | Dynamic wallpaper generator and wrapper                                 |
| 🌈 [python-pywal16](https://github.com/eylles/pywal16)                                | Color palette generation from images (Pywal fork)                       |
| 🛠️ [wpgtk](https://github.com/deviantfero/wpgtk)                                      | Universal theme template manager using Pywal                            |
| 🕶️ [nwg-look](https://github.com/nwg-piotr/nwg-look)                                  | GTK3/4 configuration customization tool for Wayland                     |
| 🎨 [papirus-icon-theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) | Material design icon theme for Linux                                    |
| 🌌 [kvantum](https://github.com/tsujan/Kvantum)                                       | SVG-based theme engine for Qt5/Qt6                                      |
| 📊 [libcava](https://github.com/karlstav/cava)                                        | Console-based Audio Visualizer shared library                           |
| 📊 [waybar-git](https://github.com/Alexays/Waybar)                                    | Highly customizable Wayland bar with Cava support                       |
| 😃 [rofimoji](https://github.com/fdw/rofimoji)                                        | Emoji, unicode and general character picker for rofi on X11 and Wayland |
| 🤖 [ydotool](https://github.com/ReimuNotMoe/ydotool)                                  | Generic command-line automation tool                                    |

### ⚡ Shell Frameworks & Plugins

| Package                                                                    | Description                                  |
| :------------------------------------------------------------------------- | :------------------------------------------- |
| 🧙‍♂️ [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)                         | Framework for managing Zsh configurations    |
| 🔮 [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | Fish-like fast shell completions as you type |

<br>

# Roadmap

- [x] Installation Dependencies
- [x] Theme switcher based on current wallpaper colors
- [x] Information Bar
- [x] App Launcher
- [x] Notifications center
- [ ] Libraries featuring a wide range of themes, with varied designs and colors
