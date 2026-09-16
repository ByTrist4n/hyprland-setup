#!/bin/bash
# =============================================================
#  Utils Functions
# =============================================================

# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Bold variables
BOLD='\033[1m'

# Function to simulate typing text smoothly
type_text() {
  local delay="${1:-0.04}"
  shift
  while [[ $# -gt 0 ]]; do
    local color="$1"
    local text="$2"
    shift 2
    printf "%b" "$color"
    for ((i = 0; i < ${#text}; i++)); do
      printf "%s" "${text:$i:1}"
      sleep "$delay"
    done
  done
  printf "%b" "${NC}"
}
export -f type_text

# Usage: print_link "URL" "TEXT" "COLOR"
print_link() {
  local url="$1"
  local text="$2"
  local color="${3:-}"
  printf "\033]8;;%s\033\\%b%s%b\033]8;;\033\\" "$url" "$color" "$text" "$NC"
}
export -f print_link

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
  echo -e "  ${GREEN}${ICON_OK}${NC} $1"
  echo ""
}
export -f log_success

log_error() {
  echo ""
  echo -e "  ${RED}${ICON_CROSS}${NC} $1"
  echo ""
}
export -f log_error

log_info() { echo -e "  ${BLUE}➜${NC} $1"; }
export -f log_info

log_warning() { echo -e "  ${RED}${ICON_WARN}️ WARNING:${NC} $1"; }
export -f log_warning

# Ask Question [Y/n] or [y/N]
ask_yes_no() {
  local prompt_text="$1"
  local default="${2:-Y}"
  local prompt_suffix

  # Combine BOLD with color directly in one ANSI sequence
  if [[ "$default" =~ ^[Yy]$ ]]; then
    prompt_suffix="\033[1;32m[Y/n]\033[0m"
  else
    prompt_suffix="\033[1;33m[y/N]\033[0m"
  fi

  while true; do
    echo ""
    echo -ne "  ${CYAN}${ICON_THINK:-[?]}${NC} ${prompt_text} ${prompt_suffix} "
    read -r yn

    # Trim leading/trailing whitespace
    yn="${yn#"${yn%%[![:space:]]*}"}"
    yn="${yn%"${yn##*[![:space:]]}"}"

    case "${yn,,}" in
      y | yes | "")
        if [[ "$default" =~ ^[Yy]$ ]]; then
          return 0
        else
          [[ -n "$yn" ]] && return 0 || return 1
        fi
        ;;
      n | no)
        return 1
        ;;
      *)
        echo -e "  ${RED}${ICON_CROSS:-[X]}${NC} Invalid input. Please answer \033[1my\033[0m or \033[1mn\033[0m."
        ;;
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

  while kill -0 "$pid" 2> /dev/null; do
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

# Detect emoji font support and setup global icon variables
setup_icons() {
  if command -v fc-list > /dev/null 2>&1 && fc-list : family | grep -iq "emoji"; then
    ICON_SPARKLE="✨"
    ICON_STAR="⭐"
    ICON_LOVE="🫰💖"
    ICON_PACKAGE="📦"
    ICON_SUCCESS="🎉"
    ICON_FLEX="💪"
    ICON_THINK="🤔"
    ICON_ARROW="➔"
    ICON_OK="✔"
    ICON_WARN="⚠"
    ICON_CROSS="❌"
  else
    ICON_SPARKLE="★"
    ICON_STAR="★"
    ICON_LOVE="♥"
    ICON_PACKAGE="⬢"
    ICON_SUCCESS="✔"
    ICON_FLEX="◆"
    ICON_THINK="?"
    ICON_ARROW="➜"
    ICON_OK="✔"
    ICON_WARN="⚠"
    ICON_CROSS="✗"
  fi

  export ICON_SPARKLE ICON_STAR ICON_LOVE ICON_PACKAGE ICON_SUCCESS \
    ICON_FLEX ICON_THINK ICON_ARROW ICON_OK ICON_WARN ICON_CROSS
}

setup_icons
