#!/bin/bash
# =============================================================
#  Troubleshooting
# =============================================================
set -e
source "./utils.sh"

options=("C Cedilla does not work" "SDDM/QT6, Need version" "Quit")
xcompose="$HOME/.XCompose"

echo -e "\n🤔 What do you want to fix?"

select opt in "${options[@]}"; do
  case $opt in
    "C Cedilla does not work")
      if [ ! -f "$xcompose" ]; then
        log_info "File $xcompose does not exist. Creating it..."
        touch "$xcompose"
      fi

      if ! grep -q "ccedilla" "$xcompose"; then
        echo 'include "%L"' >> "$xcompose"
        echo '<dead_acute> <c> : "ç" ccedilla' >> "$xcompose"
        echo '<dead_acute> <C> : "Ç" Ccedilla' >> "$xcompose"
        log_success "Done: Cedilla fix applied."
      else
        log_info "Cedilla fix is already applied."
      fi
      break
      ;;
    "SDDM/QT6, Need version")
      # Check if symlink is already pointing to Qt6
      if [ "$(readlink -f /usr/bin/sddm-greeter)" = "/usr/bin/sddm-greeter-qt6" ]; then
        log_info "SDDM is already using the Qt6 greeter."
        break
      fi

      # Backup the original Qt5 greeter binary only if it's a real file
      if [ -f /usr/bin/sddm-greeter ] && [ ! -L /usr/bin/sddm-greeter ]; then
        sudo mv /usr/bin/sddm-greeter /usr/bin/sddm-greeter.qt5
      fi

      # Symlink sddm-greeter to the Qt6 binary
      sudo ln -sf /usr/bin/sddm-greeter-qt6 /usr/bin/sddm-greeter
      log_success "Done: SDDM greeter switched to Qt6."
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
