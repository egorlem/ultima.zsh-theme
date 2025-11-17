# Vail Keybindings Module
#
# ------------------------------------------------------------------------------
# License: WTFPL – https://github.com/egorlem/ultima.zsh-theme/blob/main/LICENSE 
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Egor Lem <guezwhoz@gmail.com> / egorlem.com
#
# ------------------------------------------------------------------------------

initKeybindingsSettings() {
  bindkey '^[[A' history-substring-search-up    # стрелка вверх - поиск по истории
  bindkey '^[[B' history-substring-search-down  # стрелка вниз - поиск по истории
  
  bindkey '^[OH' beginning-of-line              # Home - в начало строки
  bindkey '^[OF' end-of-line                    # End - в конец строки
  
  bindkey '^[[3~' delete-char                   # Del - удалить символ
  bindkey '^H' backward-kill-word               # Ctrl+Backspace - удалить слово
  
  # Умное автодополнение с Tab
  bindkey '^I' complete-word
  
  echo "Ultima: keybindings module initialized"
}