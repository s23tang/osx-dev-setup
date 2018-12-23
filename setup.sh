#!/bin/bash

APP="app"
TERM="term"

is_term_tool_installed() {
  [[ $(command -v $1) != "" ]]
}

install_homebrew() {
  is_term_tool_installed brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

is_app_installed() {
  brew cask list $1 &>/dev/null || osascript -e "id of application \"$1\"" &>/dev/null
}

brew_tap_fonts() {
  (HOMEBREW_NO_AUTO_UPDATE=1 brew tap | grep -q "homebrew/cask-fonts") || brew tap caskroom/fonts
}

brew_install() {
  program_type=$1
  program_name=$2

  if [ "$program_type" = "$APP" ]; then
    is_program_installed=is_app_installed
    install="brew cask install"
  else
    is_program_installed=is_term_tool_installed
    install="brew install"
  fi

  if $($is_program_installed $program_name); then
    echo "$program_name - already installed"
  else
    echo "Installing $program_name"
    eval "$install $program_name"
  fi
}

brew_install_multiple() {
  program_type=${1}
  declare -a program_names=${!2}

  for program_name in ${program_names[@]}; do
    brew_install $program_type $program_name
  done
}

brew_install_cask_apps() {
  local apps=(iterm2 aerial spectacle atom font-hack-nerd-font)
  brew_install_multiple $APP apps[@]
}

brew_install_terminal_apps() {
  local apps=(zsh autojump bat tmux)
  brew_install_multiple $TERM apps[@]
}

install_oh_my_zsh() {
  if [ -d "$ZSH" ]; then
    echo "oh-my-zsh - already installed"
  else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  fi
}

install_zsh_autosuggestions() {
  install_path="$ZSH/custom/plugins/zsh-autosuggestions"
  if [ -d "$install_path" ]; then
    echo "zsh-autosuggestions - already installed"
  else
    git clone https://github.com/zsh-users/zsh-autosuggestions $install_path
  fi
}

install_powerlevel9k() {
  install_path="$ZSH/custom/themes/powerlevel9k"
  if [ -d "$install_path" ]; then
    echo "powerlevel9k - already installed"
  else
    git clone https://github.com/bhilburn/powerlevel9k.git $install_path
  fi
}

install_pathogen() {
  if [ -f ~/.vim/autoload/pathogen.vim ]; then
    echo "pathogen - already installed"
  else
    mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
  fi
}

install_vim_solarized_theme() {
  if [ -d ~/.vim/bundle/vim-colors-solarized ]; then
    echo "vim-colors-solarized - already installed"
  else
    git clone git://github.com/altercation/vim-colors-solarized.git ~/.vim/bundle/vim-colors-solarized
  fi
}

pre_install() {
  brew_tap_fonts
}

install_all() {
  install_homebrew
  brew_install_cask_apps
  brew_install_terminal_apps
  install_oh_my_zsh
  install_zsh_autosuggestions
  install_powerlevel9k
  install_pathogen
  install_vim_solarized_theme
}

copy_dot_files() {
  cp -i .zshrc ~/.zshrc
  cp -i .vimrc ~/.vimrc
}

set_terminal_font() {
  echo "*** Remember to set terminal font to 'Hack Regular Nerd Complete' ***"
}

set_keyboard_speed() {
  [ $(defaults read -g InitialKeyRepeat) -eq 15 ] || defaults write -g InitialKeyRepeat -int 15
  [ $(defaults read -g KeyRepeat) -eq 2 ] || defaults write -g KeyRepeat -int 2
}

set_keyboard_shortcuts() {
  # Mission Control
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 32 "{enabled = 1; value = { parameters = (106, 38, 1310720); type = 'standard'; }; }"
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 34 "{enabled = 1; value = { parameters = (106, 38, 1441792); type = 'standard'; }; }"
  # Application Windows
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 33 "{enabled = 1; value = { parameters = (107, 40, 1310720); type = 'standard'; }; }"
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 35 "{enabled = 1; value = { parameters = (107, 40, 1441792); type = 'standard'; }; }"
  # Move left a space
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 79 "{enabled = 1; value = { parameters = (104, 4, 1310720); type = 'standard'; }; }"
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 80 "{enabled = 1; value = { parameters = (104, 4, 1441792); type = 'standard'; }; }"
  # Move right a space
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 81 "{enabled = 1; value = { parameters = (108, 37, 1310720); type = 'standard'; }; }"
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 82 "{enabled = 1; value = { parameters = (108, 37, 1441792); type = 'standard'; }; }"
}

post_install() {
  copy_dot_files
  set_keyboard_speed
  set_keyboard_shortcuts
  echo ""
  set_terminal_font
}

# Let the installation begin
pre_install
install_all
post_install
