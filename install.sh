#!/bin/bash
source "./utils.sh"

source "./scripts-setup/setup-dependencies.sh"

if ask_yes_no "Do you want to configure the theme system (Pywal) ?"; then
    source "./scripts-setup/setup-pywal-theme.sh"
fi
