# Vail Ls Module
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

__ultimaLsDeps() {
  # Проверка зависимостей
  if ! command -v ls >/dev/null 2>&1; then
    echo "Ultima: error - 'ls' command not found" >&2
    return 1
  fi
  return 0
}

__ultimaLsDetectSystem() {
  # Определение типа системы
  case "$OSTYPE" in
    darwin*) echo "bsd" ;;
    linux*) echo "gnu" ;;
    freebsd*|openbsd*) echo "bsd" ;;
    *) echo "unknown" ;;
  esac
}

__ultimaLsSetupAliases() {
  # Настройка алиасов с проверкой поддержки
  local SYSTEM_TYPE=$(__ultimaLsDetectSystem)
  local HAS_COLOR_SUPPORT=0
  
  # Проверяем что LS_COLORS установлен colors модулем
  if [[ -z "$LS_COLORS" && -z "$LSCOLORS" ]]; then
    echo "Ultima: warning - colors not configured, ls will be without colors" >&2
  fi
  
  case $SYSTEM_TYPE in
    bsd)
      if ls -G / >/dev/null 2>&1; then
        alias ls='ls -G'
        alias ll='ls -laG'
        alias la='ls -laG'
        HAS_COLOR_SUPPORT=1
      else
        alias ls='ls'
        alias ll='ls -la'
        alias la='ls -la'
      fi
      ;;
    gnu)
      if ls --color=auto / >/dev/null 2>&1; then
        alias ls='ls --color=auto'
        alias ll='ls -la --color=auto'
        alias la='ls -la --color=auto'
        HAS_COLOR_SUPPORT=1
      else
        alias ls='ls'
        alias ll='ls -la'
        alias la='ls -la'
      fi
      ;;
    *)
      alias ls='ls'
      alias ll='ls -la'
      alias la='ls -la'
      ;;
  esac
  
  # Общие алиасы
  alias l='ls -CF'
  
  if [[ $HAS_COLOR_SUPPORT -eq 0 ]]; then
    echo "Ultima: warning - color support not available for ls" >&2
  fi
  
  return 0
}

__ultimaLsVerify() {
  # Проверка что алиасы установились
  if ! alias ls >/dev/null 2>&1; then
    echo "Ultima: error - failed to create ls aliases" >&2
    return 1
  fi
  
  if ! alias ll >/dev/null 2>&1; then
    echo "Ultima: error - failed to create ll alias" >&2
    return 1
  fi
  
  if ! alias la >/dev/null 2>&1; then
    echo "Ultima: error - failed to create la alias" >&2
    return 1
  fi
  
  return 0
}

ultimaLsInit() {
  # Основная функция инициализации
  local EXIT_CODE=0
  
  if ! __ultimaLsDeps; then
    return 1
  fi
  
  if ! __ultimaLsSetupAliases; then
    EXIT_CODE=1
  fi
  
  if ! __ultimaLsVerify; then
    EXIT_CODE=1
  fi
  
  local SYSTEM_TYPE=$(__ultimaLsDetectSystem)
  if [[ $EXIT_CODE -eq 0 ]]; then
    echo "Ultima: ls module initialized ($SYSTEM_TYPE system)"
  else
    echo "Ultima: ls module initialized with warnings ($SYSTEM_TYPE system)" >&2
  fi
  
  return $EXIT_CODE
}

ultimaLsStatus() {
  # Проверка статуса модуля
  if command -v ls >/dev/null 2>&1 && alias ls >/dev/null 2>&1; then
    echo "loaded"
    return 0
  else
    echo "failed" 
    return 1
  fi
}

# Автоинициализация с обработкой ошибок
if [[ -z "$ULTIMA_CORE_LOADED" ]]; then
  if ! ultimaLsInit; then
    echo "Ultima: critical - ls module failed to load" >&2
  fi
fi