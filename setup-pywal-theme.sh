#!/bin/bash
# =============================================================
#  pywal + Kvantum + qt6ct setup
# =============================================================

set -e

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
WAL_TEMPLATES="$HOME/.config/wal/templates"
KVANTUM_PYWAL="$HOME/.config/Kvantum/pywal"
QT6CT_COLORS="$HOME/.config/qt6ct/colors"
QT6CT_CONF="$HOME/.config/qt6ct/qt6ct.conf"
HYPR_SCRIPT_DIR="$HOME/.config/hypr/Trist4nScript"

STEP=0
STEP_TOTAL=7

step() {
    STEP=$((STEP + 1))
    echo "==> [$STEP/$STEP_TOTAL] $1"
}

step "Creation of folders..."
mkdir -p "$WALLPAPER_DIR"
mkdir -p "$WAL_TEMPLATES"
mkdir -p "$KVANTUM_PYWAL"
mkdir -p "$QT6CT_COLORS"
mkdir -p "$HYPR_SCRIPT_DIR"

# -------------------------------------------------------------
# Template Kvantum SVG for pywal
# -------------------------------------------------------------
step "Installation des templates pywal"
if [ -f "$WAL_TEMPLATES/pywal.svg" ]; then
    echo "Existing templates, skip."
else
    echo "Copy assets/pywal.svg and assets/pywal.kvconfig in $WAL_TEMPLATES"
    cp ./assets/kvantum/pywal.svg $WAL_TEMPLATES
    cp ./assets/kvantum/pywal.kvconfig $WAL_TEMPLATES
fi

# -------------------------------------------------------------
# Template qt6ct for pywal
# -------------------------------------------------------------
step "Creation qt6ct template..."
cp ./assets/qt/colors-qt6ct.conf $WAL_TEMPLATES

# -------------------------------------------------------------
# Symlink qt6ct/Kvantum colors → cache wal
# -------------------------------------------------------------
step "Symlink qt6ct colors..."
ln -sf "$HOME/.cache/wal/colors-qt6ct.conf" "$QT6CT_COLORS/pywal.conf"
echo "==> [4/$STEP_TOTAL] Symlink Kvantum colors..."
ln -sf "$HOME/.cache/wal/pywal.svg" "$KVANTUM_PYWAL/pywal.svg"
ln -sf "$HOME/.cache/wal/pywal.kvconfig" "$KVANTUM_PYWAL/pywal.kvconfig"

# -------------------------------------------------------------
# Config qt6ct
# -------------------------------------------------------------
step "Configuration qt6ct..."
if [ -f "$QT6CT_CONF" ]; then
    sed -i 's|color_scheme_path=.*|color_scheme_path=/home/'"$USER"'/.config/qt6ct/colors/pywal.conf|' "$QT6CT_CONF"
    sed -i 's/custom_palette=false/custom_palette=true/' "$QT6CT_CONF"
    echo "Edit $QT6CT_CONF file"
else
    mkdir -p "$(dirname "$QT6CT_CONF")"
    cp ./assets/qt6ct.conf $QT6CT_CONF
    echo "Create $QT6CT_CONF file"
fi

# -------------------------------------------------------------
# Env Variables Qt in hyprland
# -------------------------------------------------------------
step "Checking the Qt environment variables in Hyprland..."
HYPR_CONF="$HOME/.config/hypr/hyprland.lua"
if [ -f "$HYPR_CONF" ]; then
    if ! grep -q "QT_QPA_PLATFORMTHEME" "$HYPR_CONF"; then
        echo "" >> "$HYPR_CONF"
        echo "-- Qt theming" >> "$HYPR_CONF"
        echo 'hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")' >> "$HYPR_CONF"
        echo "Added to hyprland.conf"
    else
        echo "Already present in hyprland.lua"
    fi
else
    echo "WARNING: hyprland.lua not found, add manually:"
    echo "hl.env(\"QT_QPA_PLATFORMTHEME\", \"qt6ct\")"
fi

# -------------------------------------------------------------
# Install "theme-switch.sh"
# -------------------------------------------------------------
step "Install theme-switch.sh script..."
cp "$(dirname "$0")/scripts/theme-switch.sh" "$HYPR_SCRIPT_DIR/" || true
chmod +x "$HYPR_SCRIPT_DIR/theme-switch.sh" || true

# -------------------------------------------------------------
# Setup Complete
# -------------------------------------------------------------
echo ""
echo "✅ Pywal Setup complete!"
echo ""
echo "Remaining manual checklist:"
echo " 1. Copy your wallpapers to $WALLPAPER_DIR"
echo " 2. Run "$HYPR_SCRIPT_DIR/theme-switch.sh" to test"
echo " 3. Add a keyboard shortcut to switch themes --> \"hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("sh ~/.config/hypr/Trist4nScript/theme-switch.sh"))\""
