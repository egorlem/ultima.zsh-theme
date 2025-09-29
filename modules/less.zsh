# Ultima LESS Configuration Module
# Источник: ${${(%):-%x}:A}

# Ultima LESS Configuration Module
#
# This code doesn't provide much value, but it will make using zsh a little more
# enjoyable.
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Egor Lem <guezwhoz@gmail.com> / egorlem.com
#
# ------------------------------------------------------------------------------

initLessSettings() {
  export LESS='--quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4'
  export LESS_TERMCAP_mb=$'\x1b[0;36m'                              # begin bold
  export LESS_TERMCAP_md=$'\x1b[0;34m'                             # begin blink
  export LESS_TERMCAP_me=$'\x1b[0m'                           # reset bold/blink
  export LESS_TERMCAP_so=$' \x1b[0;42;30m '                # begin reverse video
  export LESS_TERMCAP_se=$' \x1b[0m'                       # reset reverse video
  export LESS_TERMCAP_us=$'\x1b[0m\x1b[0;32m'                  # begin underline
  export LESS_TERMCAP_ue=$'\x1b[0m'                            # reset underline
  export GROFF_NO_SGR=1
  
  # Регистрируем модуль
  ULTIMA_LOADED_MODULES+=(less)

  echo "Ultima: less module initialized"
}

# Автоматическая инициализация если модуль загружен напрямую
if [[ -z "$ULTIMA_CORE_LOADED" ]]; then
  initLessSettings
fi