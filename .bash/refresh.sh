printf_with_newline() {
  printf "\n$1\n"
}

refresh() {
  printf_with_newline "=====================starting brew runner====================="
  printf_with_newline "running brew update..." && brew update
  printf_with_newline "running brew upgrade..." && brew upgrade
  printf_with_newline "running brew cleanup..." && brew cleanup
  printf_with_newline "=====================brew runner complete====================="
  printf_with_newline "=====================starting nvim(plug) runner====================="
  printf_with_newline "running 'nvim --headless +PlugClean! +qall.." && nvim --headless +PlugClean! +qall
  printf_with_newline "running 'nvim --headless +PlugUpgrade +qall.." && nvim --headless +PlugUpgrade +qall
  printf_with_newline "running 'nvim --headless +PlugUpdate +qall.." && nvim --headless +PlugUpdate +qall
  printf_with_newline "=====================nvim(plug) runner complete====================="
}
