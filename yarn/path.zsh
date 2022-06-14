# sup yarn
# https://yarnpkg.com

# Make sure yarn exists
if command -v yarn &> /dev/null
then
  export PATH="$PATH:`yarn global bin`"
fi
