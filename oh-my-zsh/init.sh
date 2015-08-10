# oh-my-zsh configuration
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="bullet-train"

plugins=(git colorize vagrant brew osx colored-man docker mvn npm sbt urltools aws github rvm)

source $ZSH/oh-my-zsh.sh

# Source the dotfiles system aliases to fix conflict with oh-my-zshes ls
source $ZSHDOT/system/aliases.zsh
