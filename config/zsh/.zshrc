export XDG_CONFIG_HOME="$HOME/.config"
export ZSH_CUSTOM="$XDG_CONFIG_HOME/zsh/custom"
export ZSH="$HOME/.oh-my-zsh"

# Add ~/.local/bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# --- Headline Theme Configuration ---
typeset -A HL_GIT_STATUS_SYMBOLS

HL_SEP_MODE='on'
HL_INFO_MODE='auto'
HL_OVERWRITE='on'
HL_LAYOUT_STYLE="%{$light_black%}"
HL_LAYOUT_TEMPLATE=(
  _PRE "${IS_SSH+ %{$reset$faint%\}ssh}"
  USER ' ...'
  HOST " %{$reset$faint%}at%{$reset$HL_LAYOUT_STYLE%} ..."
  VENV " %{$reset$faint%}with%{$reset$HL_LAYOUT_STYLE%} ..."
  PATH " %{$reset$faint%}in%{$reset$HL_LAYOUT_STYLE%} ..."
  _SPACER ''
  BRANCH " %{$reset$faint%}on%{$reset$HL_LAYOUT_STYLE%} ..."
  STATUS ' ...'
  _POST ''
)
HL_LAYOUT_FIRST=(
  HOST ' ...'
  VENV ' ...'
  PATH ' ...'
  _SPACER ' '
  BRANCH ' ...'
)
HL_CONTENT_TEMPLATE=(
  USER "%{$bold$red%} ..."
  HOST "%{$bold$yellow%} ..."
  VENV "%{$bold$green%} ..."
  PATH "%{$bold$blue%} ..."
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

# --- Oh My Zsh Global Settings ---
ZSH_THEME="headline/headline"

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13

# Plugin definitions (Only native Oh My Zsh plugins)
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Source main Oh My Zsh script
source $ZSH/oh-my-zsh.sh

# --- Custom Aliases ---
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"

# Modern CLI tools integration (eza, zoxide, atuin)
if command -v eza &>/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -la --icons --octal-permissions --group-directories-first --time-style=long-iso'
  alias tree='eza --tree --icons --level=2'
  alias tree2='eza --tree --icons --level=3'
  alias tree3='eza --tree --icons --level=4'
fi

if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

if command -v atuin &>/dev/null; then
  eval "$(atuin init zsh)"
  bindkey '^[[A' atuin-up-search
fi

# Terminal startup banner
if command -v fastfetch &>/dev/null; then
  fastfetch
fi
