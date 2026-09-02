#!/bin/bash
# =============================================================
#  Utils Functions
# =============================================================
set -e

# Colors variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Bold variables
BOLD='\033[1m'

# Echo with stepper (example: [1/7])
log_step() {
    local current_file="${BASH_SOURCE[1]}"

    if [[ "$LAST_FILE" != "$current_file" ]]; then
        export LAST_FILE="$current_file"
        export STEP_TOTAL=$(grep -c 'log_step' "$current_file")
        export STEP_CURRENT=0
    fi

    export STEP_CURRENT=$((STEP_CURRENT + 1))
    echo -e "==> [$STEP_CURRENT/$STEP_TOTAL] $1"
}
export -f log_step

log_success() {
    echo -e "  ${GREEN}✔${NC} $1"
    echo ""
}
export -f log_success

log_info() { echo -e "  ${BLUE}➜${NC} $1"; }
export -f log_info

log_warn() { echo -e "  ${RED}⚠️ WARNING:${NC} $1"; }
export -f log_warn

# Ask Question [Y/n]
ask_yes_no() {
    while true; do
        read -p "$(
            echo ""
            echo -e "🤔 $1 [Y/n] "
        )" yn
        case $yn in
        "" | Yes | yes | Y | y) return 0 ;;
        No | no | N | n) return 1 ;;
        *) echo "Please answer y or n." ;;
        esac
    done
}
export -f ask_yes_no

# Spinner function to display a loading animation while running a command
spin() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'

    # Hide the terminal cursor
    tput civis

    while kill -0 "$pid" 2>/dev/null; do
        local temp=${spinstr#?}
        printf " [%c] " "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b"
    done

    # Clear spinner and restore cursor
    printf "    \b\b\b\b"
    tput cnorm
}
export -f spin
