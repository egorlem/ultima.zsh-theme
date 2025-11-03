# Vail Completion Module
#
# Enhanced Zsh completion system with caching and customizable styles
# ------------------------------------------------------------------------------
# License: WTFPL - https://github.com/egorlem/ultima.zsh-theme/blob/main/LICENSE 
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Egor Lem <guezwhoz@gmail.com> / egorlem.com
#
# ------------------------------------------------------------------------------

_ultimaCompletionDeps() {
  # Проверка что Zsh поддерживает completion систему
  if ! autoload -Uz compinit >/dev/null 2>&1; then
    echo "Vail: error - zsh completion system not available" >&2
    return 1
  fi
  return 0
}

_ultimaCompletionInitSystem() {
  # Инициализация completion системы с кешированием
  local CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  local COMPDUMP="$CACHE_DIR/.zcompdump"
  
  # Создаем директорию для кеша если нужно
  if [[ ! -d "$CACHE_DIR" ]]; then
    if ! mkdir -p "$CACHE_DIR" 2>/dev/null; then
      echo "Vail: warning - cannot create cache directory, using default" >&2
      COMPDUMP="$HOME/.zcompdump"
    fi
  fi
  
  # Оптимизированная инициализация completion
  if [[ -n "$COMPDUMP"(#qN.mh+24) ]]; then
    # Файл старше 24 часов - перекомпилируем
    compinit -d "$COMPDUMP"
  else
    # Используем кеш
    compinit -d "$COMPDUMP" -C
  fi
  
  if [[ $? -ne 0 ]]; then
    echo "Vail: error - compinit failed" >&2
    return 1
  fi
  
  return 0
}

_ultimaCompletionSetupOptions() {
  # Настройка опций completion
  setopt MENU_COMPLETE
  setopt LIST_TYPES
  setopt GLOB_COMPLETE
  
  return 0
}

_ultimaCompletionSetupStyles() {
  # Настройка стилей completion с использованием безопасных значений по умолчанию
  local COMPLETION_ARROW="›"  # Используем значение по умолчанию вместо CHAR_ARROW
  local COMPLETION_INDICATOR="%F{blue} ${COMPLETION_ARROW} %f"
  local WARNING_INDICATOR="%F{yellow} ${COMPLETION_ARROW} %f"
  local ERROR_INDICATOR="%B%F{red} ${COMPLETION_ARROW} %f"
  
  # Базовые настройки
  zstyle ':completion:*' completer _expand _complete _ignored _approximate
  zstyle ':completion:*' use-cache on
  zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompcache"
  zstyle ':completion:*' verbose yes
  zstyle ':completion:*' menu select=2
  zstyle ':completion:*' matcher-list "m:{a-z}={A-Z}"
  zstyle ':completion:*' group-name ''
  
  # Форматы сообщений
  zstyle ':completion:*:*:*:*:descriptions' format "${COMPLETION_INDICATOR}%F{green}%d%f"
  zstyle ':completion:*:*:*:*:corrections' format "${ERROR_INDICATOR}%F{yellow}%d%f (errors: %e%)"
  zstyle ':completion:*:*:*:*:warnings' format "${WARNING_INDICATOR}%F{red}no matches for: %d%f"
  zstyle ':completion:*:*:*:*:messages' format "%d"
  
  # Цвета
  if [[ -n "$LS_COLORS" ]]; then
    zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}
  else
    # Fallback colors если LS_COLORS не установлен
    zstyle ':completion:*:*:*:*:default' list-colors 'di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
  fi
  
  zstyle ':completion:*:parameters' list-colors '=*=34'
  zstyle ':completion:*:options' list-colors '=^(-- *)=34'
  zstyle ':completion:*:commands' list-colors '=*=1;34'
  
  # Продвинутые настройки
  zstyle ':completion:*:expand:*' tag-order all-expansions
  zstyle ':completion:*:approximate:*' max-errors "reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )"
  zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
  
  # Игнорируемые паттерны
  local IGNORED_FILES=("*?.o" "*?.c~" "*?.old" "*?.pro")
  zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns "${IGNORED_FILES[@]}"
  zstyle ':completion:*:functions' ignored-patterns "_*"
  
  return 0
}

_ultimaCompletionSetupHosts() {
  # Настройка дополнения для хостов с обработкой ошибок
  local HOST_FILES=(
    "/etc/ssh/ssh_known_hosts"
    "/etc/ssh/ssh_known_hosts2" 
    "$HOME/.ssh/known_hosts"
    "$HOME/.ssh/known_hosts2"
  )
  local FOUND_FILES=()
  
  for file in $HOST_FILES; do
    if [[ -f "$file" && -r "$file" ]]; then
      FOUND_FILES+=("$file")
    fi
  done
  
  if [[ ${#FOUND_FILES} -gt 0 ]]; then
    zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts \
      'reply=(${=${${(f)"$(cat ${^FOUND_FILES} 2>/dev/null)"}%%[# ]*}//,/ })'
  fi
  
  return 0
}

_ultimaCompletionVerify() {
  # Проверка что completion система работает
  if ! zstyle -L ':completion:*' >/dev/null 2>&1; then
    echo "Vail: error - completion styles not applied" >&2
    return 1
  fi
  
  return 0
}

ultimaCompletionInit() {
  # Основная функция инициализации completion
  local EXIT_CODE=0
  
  echo "Vail: initializing completion module..."
  
  if ! _ultimaCompletionDeps; then
    return 1
  fi
  
  if ! _ultimaCompletionInitSystem; then
    EXIT_CODE=1
  fi
  
  if ! _ultimaCompletionSetupOptions; then
    EXIT_CODE=1
  fi
  
  if ! _ultimaCompletionSetupStyles; then
    EXIT_CODE=1
  fi
  
  if ! _ultimaCompletionSetupHosts; then
    EXIT_CODE=1
  fi
  
  if ! _ultimaCompletionVerify; then
    EXIT_CODE=1
  fi
  
  if [[ $EXIT_CODE -eq 0 ]]; then
    echo "Vail: completion module initialized successfully"
  else
    echo "Vail: completion module initialized with warnings" >&2
  fi
  
  return $EXIT_CODE
}

ultimaCompletionStatus() {
  # Проверка статуса completion системы
  if zstyle -L ':completion:*' >/dev/null 2>&1 && compctl -L >/dev/null 2>&1; then
    echo "loaded"
    return 0
  else
    echo "failed" 
    return 1
  fi
}

# Автоинициализация с обработкой ошибок
if [[ -z "$ULTIMA_CORE_LOADED" ]]; then
  if ! ultimaCompletionInit; then
    echo "Vail: critical - completion module failed to load" >&2
  fi
fi  