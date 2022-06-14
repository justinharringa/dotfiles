### Additional setup if not already set up

1. Select Powerline in iTerm2
  * iTerm2 -> Preferences -> Profiles -> Text: should be set to Droid Sans Mono Dotted for Powerline
2. Pick Window Transparency
  * iTerm2 -> Preferences -> Profiles -> Window -> Transparency: 23

#### Automated... Previously not automated

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
  curl --silent -o ~/.oh-my-zsh/themes/bullet-train.zsh-theme https://raw.githubusercontent.com/justinharringa/bullet-train.zsh/master/bullet-train.zsh-theme
  ```
3. Powerline fonts installed: https://github.com/powerline/fonts
