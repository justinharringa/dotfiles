# Install oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]
then
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  # oh-my-zsh likes to take over .zshrc - we're covering its bases already elsewhere
  cp $HOME/.zshrc $HOME/.zshrc.post-oh-my-zsh-install
  cp $HOME/.zshrc.pre-oh-my-zsh $HOME/.zshrc
fi

# Install bullet-train
curl --silent -o ~/.oh-my-zsh/themes/bullet-train.zsh-theme https://raw.githubusercontent.com/justinharringa/bullet-train.zsh/master/bullet-train.zsh-theme
