export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/custom"

# --- Oh My Zsh Global Configuration ---

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="headline/headline"

zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' frequency 13

# Plugins list
plugins=(
  git
  zsh-autosuggestions 
  zsh-syntax-highlighting
  zoxide
  fzf
  aliases
)

source $ZSH/oh-my-zsh.sh

# --- OVERRIDE HEADLINE THEME VARIABLES (AFTER SOURCING) ---

HL_SEP_MODE='on'
HL_INFO_MODE='auto'
HL_OVERWRITE='on'
HL_LAYOUT_STYLE="%{$light_black%}"
HL_LAYOUT_TEMPLATE=(
  _PRE    "${IS_SSH+ %{$reset$faint%\}ssh}" # shows " ssh" if this is an SSH session
  USER    ' ...'
  HOST    " %{$reset$faint%}at%{$reset$HL_LAYOUT_STYLE%} ..."
  VENV    " %{$reset$faint%}with%{$reset$HL_LAYOUT_STYLE%} ..."
  PATH    " %{$reset$faint%}in%{$reset$HL_LAYOUT_STYLE%} ..."
  _SPACER ''
  BRANCH  " %{$reset$faint%}on%{$reset$HL_LAYOUT_STYLE%} ..."
  STATUS  ' ...'
  _POST   ''
)
HL_LAYOUT_FIRST=(
  HOST    ' ...'
  VENV    ' ...'
  PATH    ' ...'
  _SPACER ' '
  BRANCH  ' ...'
)
HL_CONTENT_TEMPLATE=(
  USER   "%{$bold$red%} ..."
  HOST   "%{$bold$yellow%} ..."
  VENV   "%{$bold$green%} ..."
  PATH   "%{$bold$blue%} ..."
  BRANCH "%{$bold$cyan%} ..."
  STATUS "%{$bold$magenta%}..."
)
HL_GIT_SEP_SYMBOL=''
HL_GIT_STATUS_SYMBOLS[CONFLICTS]="%{$red%}✘"
HL_GIT_STATUS_SYMBOLS[CLEAN]="%{$green%}✔"
HL_PROMPT="%{$HL_LAYOUT_STYLE%} %{$reset%}$ "
HL_CLOCK_MODE='on'
HL_CLOCK_TEMPLATE="%{$faint%} ... %{$reset$HL_LAYOUT_STYLE%}"
HL_ERR_MODE='on'

# --- User configuration ---

# -- Aliases --
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
# Standard grid view with icons
alias ls='eza --icons --group-directories-first'
# Detailed list view
alias ll='eza -la --icons --octal-permissions --group-directories-first --time-style=long-iso'
# Tree view with git status and depth restriction
alias tree='eza --tree --icons --level=2'

# Atuin plugin configuration
eval "$(atuin init zsh)"
bindkey '^[[A' atuin-up-search

# Launch fastfetch on terminal startup
fastfetch
