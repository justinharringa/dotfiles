if test "$(uname)" = "Darwin" ; then
  # MacOS
  font_dir="$HOME/Library/Fonts"
  font_file="${font_dir}/Droid Sans Mono Dotted for Powerline.ttf"
  if [[ ! -f "${font_file}" ]]
  then
    curl --silent -o "${font_file}" https://github.com/powerline/fonts/blob/master/DroidSansMonoDotted/Droid%20Sans%20Mono%20Dotted%20for%20Powerline.ttf
  fi
fi
