<div align="center">

[![Typing SVG](https://readme-typing-svg.demolab.com?font=Sixtyfour&size=24&pause=1000&color=1793d1&width=435&lines=Hyprland+Setup;ByTrist4n)](https://git.io/typing-svg)

[![GitHub stars](https://img.shields.io/github/stars/ByTrist4n/hyprland-setup?style=for-the-badge&logo=github&color=daaa3f&labelColor=252733)](https://github.com/ByTrist4n/hyprland-setup)
[![Last Commit](https://img.shields.io/github/last-commit/ByTrist4n/hyprland-setup?style=for-the-badge&labelColor=252733)](https://github.com/ByTrist4n/hyprland-setup)
[![Repo Size](https://img.shields.io/github/repo-size/ByTrist4n/hyprland-setup?style=for-the-badge&logo=codesandbox&color=DDB&labelColor=252733)](https://github.com/ByTrist4n/hyprland-setup)
[![Hyprland](https://img.shields.io/badge/Hyprland-v0.55%2B-1793d1?logo=hyprland&style=for-the-badge&logoColor=1793d1&labelColor=252733)](https://github.com/ByTrist4n/hyprland-setup)
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#what-is-it">What is it?</a>
      <ul>
        <li><a href="#showcase">Showcase</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#features">Features</a></li>
    <li>
      <a href="#tech-stack">Tech Stack</a>
      <ul>
        <li><a href="#--core-pacman-packages">📦 Core Pacman Packages</a></li>
        <li><a href="#--core-aur-packages">🛸 Core AUR Packages</a></li>
        <li><a href="#--optional-extra-applications">💡 Optional Extra Applications</a></li>
      </ul>
    </li>
    <li><a href="#ideas--feedback-">Ideas & Feedback 💡</a></li>
    <li><a href="#bug-reports-">Bug Reports 🐛</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
  </ol>
</details>

# What is it?

A simplified, automated configuration script that allows you to create a polished, functional Hyprland environment with a single command. Ideal for new Arch Linux / CachyOS installations or when you want to revamp your desktop workflow.

> ⭐ Thank you for supporting the project with a star 🫰💖

## Showcase

Main desktop overview:

![Screenshot Desktop](./screenshots/screenshot_preview.jpg)

<details>
  <summary><b>✨ Click to expand full gallery</b></summary>
  <br>

**Information Bar**
![Screenshot Desktop](./screenshots/screenshot_desktop.jpg)

**App Launcher**
![Screenshot Launch](./screenshots/screenshot_launch.jpg)

**Notification Center**
![Screenshot Notification](./screenshots/screenshot_notification.jpg)

**Theme Switcher**
![Screenshot Switch Theme](./screenshots/screenshot_theme_switch.jpg)

</details>

<br>

# Getting Started

## Prerequisites

**Hyprland v0.55+** (Lua configuration format support). Verify your installed version with: `hyprland --version`

## Installation

Clone the repository and run the setup script:

```bash
git clone https://github.com/ByTrist4n/hyprland-setup.git
cd hyprland-setup
sh install.sh
```

<br>

# Features

- **Quickshell Bar & UI**: Modern, desktop status bar and controls powered by Quickshell.
- **Dynamic Theme Engine**: Automatic wallpaper color extraction via `pywal-16-git` and `wpgtk` applied across GTK, Qt, and shell environments.
- **Modern Screenshot Workflow**: Seamless screen region capture using `grim`, `slurp`, and markup editing with `satty`.
- **Custom App Launcher**: Rofi-based launcher, window switcher, and unicode emoji picker.
- **Interactive Script**: Modular dependency installer with optional extra applications.

<br>

# Tech Stack

[![Arch Linux](https://img.shields.io/badge/Arch%20Linux-1793D1?logo=arch-linux&logoColor=fff&style=for-the-badge)](https://archlinux.org)
[![Hyprland](https://img.shields.io/badge/Hyprland-blue?style=for-the-badge&logo=hyprland)](https://hypr.land)

These are all the packages installed with "Hyprland Setup":
<details>
  <summary><b>📦 Core Pacman Packages</b></summary>

| Package                                                                                                | Description                                                      |
| :----------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------- |
| 🪟 [hyprland](https://github.com/hyprwm/Hyprland)                                                      | Dynamic tiling Wayland compositor                                |
| 🐚 [quickshell](https://quickshell.org/)                                                               | Flexible toolkit for building desktop shells with QML            |
| 🔒 [hyprlock](https://github.com/hyprwm/hyprlock)                                                      | Fast and GPU-accelerated screen locker                           |
| 💤 [hypridle](https://github.com/hyprwm/hypridle)                                                      | Wayland-native idle management daemon                            |
| 🐱 [kitty](https://github.com/kovidgoyal/kitty)                                                        | Fast, feature-rich, GPU-based terminal emulator                  |
| 🔍 [rofi](https://github.com/davatorium/rofi)                                                          | Application launcher and window switcher                         |
| 🐬 [dolphin](https://invent.kde.org/system/dolphin)                                                    | KDE file manager                                                 |
| 📸 [grim](https://sr.ht/~emersion/grim) / [slurp](https://github.com/emersion/slurp)                   | Wayland screenshot tool and region selector                      |
| 🎨 [satty](https://github.com/gabm/satty)                                                              | Modern screenshot annotation utility                             |
| 🔊 [pavucontrol](https://gitlab.freedesktop.org/pulseaudio/pavucontrol)                                | PipeWire / PulseAudio volume control GUI                         |
| 🔵 [blueman](https://github.com/blueman-project/blueman)                                               | GTK-based Bluetooth manager                                      |
| ☀️ [brightnessctl](https://github.com/Hummer12007/brightnessctl)                                       | Screen brightness control utility                                |
| 📊 [cava](https://github.com/karlstav/cava)                                                            | Console-based Audio Visualizer                                   |
| 📜 [cliphist](https://github.com/Sentriz/cliphist)                                                     | Wayland clipboard manager for text and images                    |
| 📋 [wl-clipboard](https://github.com/bugaevc/wl-clipboard)                                             | Command-line copy/paste utilities                                |
| ⌨️ [fcitx5](https://github.com/fcitx/fcitx5)                                                           | Input method framework (`fcitx5-gtk`, `fcitx5-qt`, `configtool`) |
| 🎨 [qt5ct](https://sourceforge.net/projects/qt5ct/) / [qt6ct](https://sourceforge.net/projects/qt5ct/) | Qt theme configuration utilities                                 |
| 🌌 [kvantum](https://github.com/tsujan/Kvantum)                                                        | SVG-based theme engine for Qt applications                       |
| 🎨 [papirus-icon-theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)                  | SVG-based icon theme                                             |
| 🔤 [ttf-jetbrains-mono-nerd](https://github.com/ryanoasis/nerd-fonts)                                  | Developer font with icon glyphs                                  |
| 📹 [wf-recorder](https://github.com/ammen99/wf-recorder)                                               | Wayland screen recording tool                                    |
| 📝 [nvim](https://github.com/neovim/neovim)                                                            | Vim-based text editor for configuration editing                  |
| 🐚 [zsh](https://github.com/zsh-users/zsh)                                                             | Z shell environment                                              |
| 🚀 [yay](https://github.com/Jguer/yay)                                                                 | Arch User Repository helper                                      |
| 🌐 [nm-connection-editor](https://gitlab.gnome.org/GNOME/network-manager-applet)                       | NetworkManager GUI editor                                        |
| 🔒 [sddm](https://github.com/sddm/sddm)                                                                | QML-based display manager                                        |
| 📑 [archlinux-xdg-menu](https://archlinux.org/packages/extra/any/archlinux-xdg-menu/)                  | XDG menu generator                                               |
| 📦 [zip](https://infozip.sourceforge.net/)                                                             | Compression utility                                              |

</details>

<details>
  <summary><b>🛸 Core AUR Packages</b></summary>

| Package                                              | Description                                      |
| :--------------------------------------------------- | :----------------------------------------------- |
| 🖼️ [awww](https://codeberg.org/LGFae/awww)           | Dynamic wallpaper daemon                         |
| 🌈 [pywal-16-git](https://github.com/eylles/pywal16) | 16-color palette generator from wallpaper images |
| 🛠️ [wpgtk](https://github.com/deviantfero/wpgtk)     | Color scheme template engine based on Pywal      |
| 🕶️ [nwg-look](https://github.com/nwg-piotr/nwg-look) | GTK3/4 customization tool for Wayland            |
| 🚪 [wlogout](https://github.com/ArtsyMacaw/wlogout)  | Wayland logout menu interface                    |
| 😃 [rofimoji](https://github.com/fdw/rofimoji)       | Rofi emoji and character picker                  |
| 🤖 [ydotool](https://github.com/ReimuNotMoe/ydotool) | Wayland command-line input automation tool       |

</details>

<details>
  <summary><b>💡 Optional Extra Applications</b></summary>

| Package                                                      | Source | Description                                 |
| :----------------------------------------------------------- | :----- | :------------------------------------------ |
| 📄 [libreoffice-still](https://www.libreoffice.org/)         | Pacman | Stable office suite                         |
| 📂 [yazi](https://github.com/sxyazi/yazi)                    | Pacman | Fast terminal file manager written in Rust  |
| 💻 [vscodium-bin](https://github.com/VSCodium/vscodium)      | AUR    | Telemetry-free open-source build of VS Code |
| 🧭 [zen-browser](https://github.com/zen-browser/desktop)     | AUR    | Firefox-based browser focused on privacy    |
| 🎵 [pear-desktop](https://github.com/pear-devs/pear-desktop) | AUR    | YouTube Music desktop client                |
| 🖱️ [logiops](https://github.com/PixlOne/logiops)             | AUR    | Driver and utility for Logitech mice        |

</details>

<br>

# Ideas & Feedback 💡

Have a feature request or an idea? Feel free to start a thread in the [Discussions section](https://github.com/ByTrist4n/hyprland-setup/discussions).

# Bug Reports 🐛

Encountered an issue? Open a ticket in the [Issues section](https://github.com/ByTrist4n/hyprland-setup/issues).

# Roadmap

- [x] Automated dependency installation script
- [x] Dynamic wallpaper-based theme generation (`pywal-16-git` + `wpgtk`)
- [x] Quickshell bar integration
- [x] Screenshot and markup workflow (`grim` + `slurp` + `satty`)
- [x] Interactive installation menu with optional software selection
- [ ] Quickshell widget library
  - [ ] Music pop-up control
  - [ ] Todo block
  - [ ] Add a “Do Not Disturb” mode for notifications
- [ ] Calculator in Rofi
- [ ] A collection of themes with different designs and colors
- [ ] And more...
