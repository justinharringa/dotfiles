# oh-my-zsh configuration
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git colorize kubectl brew macos colored-man-pages docker golang mvn npm sbt urltools aws github rvm ruby gem rake autojump iterm2 1password tmux pyenv gh poetry)

source $ZSH/oh-my-zsh.sh

# Source the dotfiles system aliases to fix conflict with oh-my-zshes ls
source $ZSHDOT/system/aliases.zsh
