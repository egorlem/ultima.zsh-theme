# Vail History Module
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

__ultimaHistorySetupEnv() {
  # Настройка переменных окружения для истории
  export HISTFILE="$HOME/.zsh_history"
  export HISTSIZE=100000
  export SAVEHIST=100000
  
  # Проверка что файл истории доступен для записи
  local HIST_DIR="${HISTFILE:h}"
  if [[ ! -d "$HIST_DIR" ]]; then
    if ! mkdir -p "$HIST_DIR" 2>/dev/null; then
      echo "Ultima: error - cannot create history directory $HIST_DIR" >&2
      return 1
    fi
  fi
  
  if [[ ! -w "$HIST_DIR" ]]; then
    echo "Ultima: error - history directory $HIST_DIR is not writable" >&2
    return 1
  fi
  
  return 0
}

__ultimaHistorySetupOptions() {
  # Настройка опций истории
  setopt EXTENDED_HISTORY        # timestamp в истории
  setopt HIST_EXPIRE_DUPS_FIRST  # удалять дубли сначала
  setopt HIST_IGNORE_DUPS        # игнорировать повторения
  setopt HIST_IGNORE_ALL_DUPS    # удалять старые дубли
  setopt HIST_FIND_NO_DUPS       # не показывать дубли в поиске
  setopt HIST_IGNORE_SPACE       # не сохранять команды с пробелом вначале
  setopt HIST_REDUCE_BLANKS      # удалять лишние пробелы
  setopt HIST_VERIFY             # показывать команду перед выполнением
  setopt SHARE_HISTORY           # делиться историей между сессиями
  
  return 0
}

__ultimaHistorySetupAliases() {
  # Настройка алиасов для работы с историей
  alias history='fc -l 1'        # нормальный вывод истории
  alias h='history'
  
  # Проверяем что grep доступен для hg алиаса
  if command -v grep >/dev/null 2>&1; then
    alias hg='history | grep'
  else
    echo "Ultima: warning - grep not found, hg alias disabled" >&2
  fi
  
  return 0
}

__ultimaHistoryVerify() {
  # Проверка что настройки применились
  if [[ -z "$HISTFILE" ]]; then
    echo "Ultima: error - HISTFILE not set" >&2
    return 1
  fi
  
  if ! alias history >/dev/null 2>&1; then
    echo "Ultima: error - history aliases not created" >&2
    return 1
  fi
  
  return 0
}

ultimaHistoryInit() {
  # Основная функция инициализации
  local EXIT_CODE=0
  
  if ! __ultimaHistorySetupEnv; then
    EXIT_CODE=1
  fi
  
  if ! __ultimaHistorySetupOptions; then
    EXIT_CODE=1
  fi
  
  if ! __ultimaHistorySetupAliases; then
    EXIT_CODE=1
  fi
  
  if ! __ultimaHistoryVerify; then
    EXIT_CODE=1
  fi
  
  if [[ $EXIT_CODE -eq 0 ]]; then
    echo "Ultima: history module initialized (HISTSIZE: $HISTSIZE)"
  else
    echo "Ultima: history module initialized with warnings" >&2
  fi
  
  return $EXIT_CODE
}

ultimaHistoryStatus() {
  # Проверка статуса модуля
  if [[ -n "$HISTFILE" && -n "$HISTSIZE" && alias history >/dev/null 2>&1 ]]; then
    echo "loaded"
    return 0
  else
    echo "failed"
    return 1
  fi
}

# Автоинициализация с обработкой ошибок
if [[ -z "$ULTIMA_CORE_LOADED" ]]; then
  if ! ultimaHistoryInit; then
    echo "Ultima: critical - history module failed to load" >&2
  fi
fi