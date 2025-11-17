# Vail Navigation Module
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

__ultimaNavigationSetupOptions() {
  # Настройка опций навигации
  setopt AUTO_CD           # cd без ввода cd
  setopt AUTO_PUSHD        # автоматически пушить директории в стек
  setopt PUSHD_IGNORE_DUPS # не пушить дубликаты в стек
  setopt PUSHD_SILENT      # не выводить стек при pushd/popd
  
  return 0
}

__ultimaNavigationSetupAliases() {
  # Настройка алиасов для навигации
  alias ..='cd ..'
  alias ...='cd ../..'
  alias ....='cd ../../..'
  alias .....='cd ../../../..'
  
  alias d='dirs -v'        # показать стек директорий
  alias 1='cd -'
  alias 2='cd -2'
  alias 3='cd -3'
  
  # Быстрый переход в частые директории (опционально)
  if [[ -d "$HOME/Development" ]]; then
    alias dev='cd ~/Development'
  fi
  
  if [[ -d "$HOME/Documents" ]]; then
    alias docs='cd ~/Documents'
  fi
  
  if [[ -d "$HOME/Downloads" ]]; then
    alias down='cd ~/Downloads'
  fi
  
  return 0
}

__ultimaNavigationVerify() {
  # Проверка что алиасы установились
  if ! alias .. >/dev/null 2>&1; then
    echo "Ultima: error - failed to create navigation aliases" >&2
    return 1
  fi
  
  if ! alias d >/dev/null 2>&1; then
    echo "Ultima: error - failed to create dirs alias" >&2
    return 1
  fi
  
  return 0
}

ultimaNavigationInit() {
  # Основная функция инициализации
  local EXIT_CODE=0
  
  if ! __ultimaNavigationSetupOptions; then
    EXIT_CODE=1
  fi
  
  if ! __ultimaNavigationSetupAliases; then
    EXIT_CODE=1
  fi
  
  if ! __ultimaNavigationVerify; then
    EXIT_CODE=1
  fi
  
  if [[ $EXIT_CODE -eq 0 ]]; then
    echo "Ultima: navigation module initialized"
  else
    echo "Ultima: navigation module initialized with warnings" >&2
  fi
  
  return $EXIT_CODE
}

ultimaNavigationStatus() {
  # Проверка статуса модуля
  if alias .. >/dev/null 2>&1 && alias d >/dev/null 2>&1; then
    echo "loaded"
    return 0
  else
    echo "failed"
    return 1
  fi
}

# Автоинициализация с обработкой ошибок
if [[ -z "$ULTIMA_CORE_LOADED" ]]; then
  if ! ultimaNavigationInit; then
    echo "Ultima: critical - navigation module failed to load" >&2
  fi
fi