### Additional setup if not already set up

1. Install [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
#### via curl
```shell
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```
#### via wget
```shell
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
```
2. Install bullet-train theme
```shell
wget -P ~/.oh-my-zsh/themes/ http://raw.github.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme
```
3. Powerline fonts installed: https://github.com/powerline/fonts
  * iTerm2 -> Preferences -> Profiles -> Text: should be set to Droid Sans Mono Dotted for Powerline
  * iTerm2 -> Preferences -> Profiles -> Report Terminal Type: set to xterm-256color
