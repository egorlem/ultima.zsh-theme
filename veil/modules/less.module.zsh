# Vail Less Module
#
# ------------------------------------------------------------------------------
# License: WTFPL - https://github.com/egorlem/ultima.zsh-theme/blob/main/LICENSE 
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Egor Lem <guezwhoz@gmail.com> / egorlem.com
#
# ------------------------------------------------------------------------------

__ultimaLessDeps() {
  # Проверка зависимостей
  if ! command -v less >/dev/null 2>&1; then
    echo "Ultima: error - 'less' command not found" >&2
    return 1
  fi
  return 0
}

__ultimaLessValidateTerm() {
  # Проверка поддержки терминалом
  if [[ "$TERM" == "dumb" || "$TERM" == "unknown" ]]; then
    echo "Ultima: warning - terminal may not support less features" >&2
    return 1
  fi
  return 0
}

__ultimaLessSetupEnv() {
  # Настройка переменных окружения с валидацией
  local LESS_OPTS="--quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4"
  
  if ! LESS="$LESS_OPTS" less --version >/dev/null 2>&1; then
    echo "Ultima: warning - some less options not supported, using minimal set" >&2
    LESS_OPTS="--quit-if-one-screen --ignore-case --LONG-PROMPT --tabs=4"
  fi
  
  export LESS="$LESS_OPTS"
  export GROFF_NO_SGR=1
  
  # TERMCAP настройки только если поддерживается
  if __ultimaLessValidateTerm; then
    export LESS_TERMCAP_mb=$'\x1b[0;36m'    # begin bold
    export LESS_TERMCAP_md=$'\x1b[0;34m'    # begin blink  
    export LESS_TERMCAP_me=$'\x1b[0m'       # reset bold/blink
    export LESS_TERMCAP_so=$' \x1b[0;42;30m ' # begin reverse video
    export LESS_TERMCAP_se=$' \x1b[0m'      # reset reverse video
    export LESS_TERMCAP_us=$'\x1b[0m\x1b[0;32m' # begin underline
    export LESS_TERMCAP_ue=$'\x1b[0m'       # reset underline
  fi
  
  return 0
}

__ultimaLessSetupAliases() {
  # Настройка алиасов для less
  alias less='less --RAW-CONTROL-CHARS'   # Always ensure color support
  alias more='less'                       # Use less instead of more
  
  # Настройка man pages для использования less
  export MANPAGER="less -s -M +Gg"
  export MANWIDTH=80
  
  return 0
}

__ultimaLessSetupHelpers() {
  # Функции-хелперы для расширенного использования
  
  lessSearch() {
    # Поиск текста в файле через less
    # Usage: lessSearch "pattern" filename
    less -p "$1" "$2"
  }

  lessTail() {
    # Просмотр логов в реальном времени  
    # Usage: lessTail filename
    less +F "$1"
  }
  
  return 0
}

__ultimaLessAdaptToTerminal() {
  # Адаптация под возможности терминала
  case "$TERM" in
    "xterm-kitty")
      # Kitty terminal has better scrollback
      export LESS="--quit-if-one-screen --ignore-case --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4"
      ;;
    "linux"|"console")
      # Simplified for limited terminals
      export LESS="--quit-if-one-screen --ignore-case --LONG-PROMPT --tabs=4"
      export MANPAGER="less -s -M"
      ;;
  esac
  
  return 0
}

__ultimaLessVerify() {
  # Финальная проверка что все работает
  if [[ -z "$LESS" ]]; then
    echo "Ultima: error - LESS environment variable not set" >&2
    return 1
  fi
  
  if ! command -v less >/dev/null 2>&1; then
    echo "Ultima: error - less command disappeared" >&2
    return 1
  fi
  
  return 0
}

ultimaLessInit() {
  # Основная функция инициализации
  local EXIT_CODE=0
  
  if ! __ultimaLessDeps; then
    return 1
  fi
  
  if ! __ultimaLessSetupEnv; then
    EXIT_CODE=1
  fi
  
  if ! __ultimaLessSetupAliases; then
    EXIT_CODE=1
  fi
  
  if ! __ultimaLessSetupHelpers; then
    EXIT_CODE=1
  fi
  
  if ! __ultimaLessAdaptToTerminal; then
    EXIT_CODE=1
  fi
  
  if ! __ultimaLessVerify; then
    EXIT_CODE=1
  fi
  
  if [[ $EXIT_CODE -eq 0 ]]; then
    echo "Ultima: less module initialized"
  else
    echo "Ultima: less module initialized with warnings" >&2
  fi
  
  return $EXIT_CODE
}

ultimaLessStatus() {
  # Проверка статуса модуля
  if [[ -n "$LESS" ]] && command -v less >/dev/null 2>&1; then
    echo "loaded"
    return 0
  else
    echo "failed" 
    return 1
  fi
}

# Автоинициализация с обработкой ошибок
if [[ -z "$ULTIMA_CORE_LOADED" ]]; then
  if ! ultimaLessInit; then
    echo "Ultima: critical - less module failed to load" >&2
  fi
fi