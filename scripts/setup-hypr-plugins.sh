if ask_yes_no "Would you like to set up \"Hyprland Plugins\", to enable the Hyprbars plugin?"; then
    hyprpm update 
    
    # Add official plugin repository if not already installed
    if ! hyprpm list | grep -q "hyprland-plugins"; then
        hyprpm add https://github.com/hyprwm/hyprland-plugins
        hyprpm enable hyprbars
    fi

    # Ensure target directory exists
    mkdir -p "$HOME/.config/hypr/config/plugins"

    
    cp "./scripts/hypr/config/plugins/hyprbars.lua" "$HOME/.config/hypr/config/plugins/hyprbars.lua"

    # Safely append require call after the last require line in hyprland.lua
    HYPR_CONFIG="$HOME/.config/hypr/hyprland.lua"
    TARGET_REQ='require("config/plugins/hyprbars")'

    if [ -f "$HYPR_CONFIG" ] && ! grep -qF "$TARGET_REQ" "$HYPR_CONFIG"; then
        # Find last line matching 'require' and insert target requirement right after it
        LAST_REQ_LINE=$(grep -n 'require' "$HYPR_CONFIG" | tail -n 1 | cut -d: -f1)

        if [ -n "$LAST_REQ_LINE" ]; then
            sed -i "${LAST_REQ_LINE}a ${TARGET_REQ}" "$HYPR_CONFIG"
        else
            echo "$TARGET_REQ" >> "$HYPR_CONFIG"
        fi
    fi
fi