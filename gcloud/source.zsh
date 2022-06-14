if [[ -d "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/" ]]
then
  source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
  source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi
