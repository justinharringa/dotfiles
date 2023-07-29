# oh-my-zsh configuration
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="bullet-train"

plugins=(git colorize kubectl brew macos colored-man-pages docker golang mvn npm sbt urltools aws github rvm ruby gem rake autojump iterm2 1password tmux)

source $ZSH/oh-my-zsh.sh

# Source the dotfiles system aliases to fix conflict with oh-my-zshes ls
source $ZSHDOT/system/aliases.zsh
