#!/bin/bash
# =============================================================
#  Troubleshooting
# =============================================================
set -e
source "./utils.sh"

options=("C Cedilla does not work" "Quit")
xcompose="$HOME/.XCompose"

echo -e "\n🤔 What do you want to fix?"

select opt in "${options[@]}"; do
    case $opt in
        "C Cedilla does not work")
             if [ ! -f "$xcompose" ]; then
                log_info "File $xcompose does not exist. Creating it..."
                touch "$xcompose"
            fi

            if ! grep -q "ç" "$xcompose"; then
                echo 'include "%L"' >> $xcompose
                echo '<dead_acute> <c> : "ç" ccedilla' >> $xcompose
                echo '<dead_acute> <C> : "Ç" Ccedilla' >> $xcompose
                log_success "Done: Cedilla fix applied."
            else
                log_info "Cedialla's fix is ​​already done"
            fi
            break
            ;;
        "Quit")
            echo "Exiting."
            exit 0
            ;;
        *) 
            echo "Invalid option $REPLY" 
            ;;
    esac
done