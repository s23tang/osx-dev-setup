# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/usr/local/opt/python/libexec/bin:$PATH

# 256 colors for tmux
export TERM="xterm-256color"

# Path to your oh-my-zsh installation.
export ZSH="/Users/tedtang/.oh-my-zsh"

# Powerline configs
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs virtualenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_beginning"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_COLOR_SCHEME='light'
POWERLEVEL9K_HIDE_BRANCH_ICON=true

ZSH_THEME="powerlevel9k/powerlevel9k"

plugins=(
  git
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

alias dcp=docker-compose

# Autojump config
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# Bat theme
export BAT_THEME="OneHalfLight"
