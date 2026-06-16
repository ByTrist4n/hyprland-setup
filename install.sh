#!/bin/bash
echo "                         _                 _   __      _               ";
echo "  /\\  /\\_   _ _ __  _ __| | __ _ _ __   __| | / _\\ ___| |_ _   _ _ __  ";
echo " / /_/ / | | | '_ \\| '__| |/ _\` | '_ \\ / _\` | \\ \\ / _ \\ __| | | | '_ \\ ";
echo "/ __  /| |_| | |_) | |  | | (_| | | | | (_| | _\\ \\  __/ |_| |_| | |_) |";
echo "\\/ /_/  \\__, | .__/|_|  |_|\\__,_|_| |_|\\__,_| \\__/\\___|\\__|\\__,_| .__/ ";
echo "        |___/|_|                                                |_|    ";
echo ""
echo "By Tris4n"

source "./utils.sh"

source "./scripts-setup/setup-dependencies.sh"

if ask_yes_no "Do you want to configure the theme system (Pywal) ?"; then
    source "./scripts-setup/setup-pywal-theme.sh"
fi

echo -e "🤔 Having trouble? Use the troubleshooting script to resolve the issue. Run the following command: ${BOLD}sh troubleshooting.sh${NC}"