export PYENV_VERSION=3
eval "$(pyenv init - zsh)"
pyenv install ${PYENV_VERSION}
pyenv global "$(pyenv latest ${PYENV_VERSION})" system
