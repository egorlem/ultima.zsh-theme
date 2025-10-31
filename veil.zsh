# Veil - https://github.com/egorlem/ultima.zsh-theme
#
# Modular Z Shell Configuration System
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Egor Lem <guezwhoz@gmail.com> / egorlem.com
#
# ------------------------------------------------------------------------------

# ==============================================================================
# CORE CONFIGURATION
# ==============================================================================

VEIL_VERSION="p3.c8"
VEIL_DIR="${0:A:h}"
DEFAULT_VEIL_MODULES_DIR="$VEIL_DIR/veil/modules"

# Поддержка кастомного пути к модулям
if [[ -z "$VEIL_MODULES_DIR" ]]; then
    MODULES_DIR="$DEFAULT_VEIL_MODULES_DIR"
else
    MODULES_DIR="$VEIL_MODULES_DIR"
fi

# Поддержка кастомного списка модулей
if [[ -z "$VEIL_MODULES" ]]; then
    VEIL_MODULES=("less" "ls" "completion")
else
    # Разбиваем строку с модулями на массив (если передана как строка)
    VEIL_MODULES=(${(@s: :)VEIL_MODULES})
fi

# Поддержка кастомного пути к темам
if [[ -z "$VEIL_THEMES_DIR" ]]; then
    THEMES_DIR="$VEIL_DIR"
else
    THEMES_DIR="$VEIL_THEMES_DIR"
fi

# Имя темы по умолчанию
if [[ -z "$THEME_NAME" ]]; then
    THEME_NAME="ultima"
fi

# ==============================================================================
# SHARED VARIABLES (available to all modules)
# ==============================================================================

# Color schemes for LS and completion
LSCOLORS="gxafexdxfxagadabagacad"                                                                   # BSD
LS_COLORS="di=36:ln=30;45:so=34:pi=33:ex=35:bd=30;46:cd=30;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"  # GNU
export LSCOLORS LS_COLORS

# ==============================================================================
# MODULE SYSTEM
# ==============================================================================

_veilLoadModule() {
  local module_file="$MODULES_DIR/$1.module.zsh"
  if [[ -f "$module_file" ]]; then
    source "$module_file"
  else
    echo "Veil: module $1 not found at $module_file"
  fi
}


_veilLoadTheme() {
  local THEME_FILE="$THEMES_DIR/${THEME_NAME}.zsh-theme"
    
  # Проверяем существование файла темы
  if [[ ! -f "$THEME_FILE" ]]; then
      echo "Veil: error - theme file not found: $THEME_FILE" >&2
      return 1
  fi
  
  # Проверяем возможность чтения файла
  if [[ ! -r "$THEME_FILE" ]]; then
      echo "Veil: error - cannot read theme file: $THEME_FILE" >&2
      return 1
  fi
  
  # Загружаем тему
  if source "$THEME_FILE"; then
      [[ -n "$VEIL_VERBOSE" ]] && echo "Veil: theme '$THEME_NAME' loaded successfully"
      return 0
  else
      echo "Veil: error - failed to load theme '$THEME_NAME'" >&2
      return 1
  fi
}

# Load modules if available
if [[ -d "$MODULES_DIR" ]]; then
  for module in $VEIL_MODULES; do
    _veilLoadModule "$module"
  done
else
  echo "Veil: running in minimal mode without modules"
fi

VEIL_CORE_LOADED=1

# Load theme
if ! _veilLoadTheme; then
    echo "Veil: warning - theme loading failed, continuing without theme" >&2
fi


# ==============================================================================
# CLI LOADING
# ==============================================================================

# Загружаем CLI если он доступен
# ULTIMA_CLI_FILE="$ULTIMA_DIR/veil/_cli.zsh"

# if [[ -f "$ULTIMA_CLI_FILE" && -r "$ULTIMA_CLI_FILE" ]]; then
#     if source "$ULTIMA_CLI_FILE"; then
#         [[ -n "$VEIL_VERBOSE" ]] && echo "Ultima: CLI loaded successfully"
#     else
#         echo "Ultima: warning - failed to load CLI" >&2
#     fi
# else
#     echo "Ultima: CLI file not found at $ULTIMA_CLI_FILE" >&2
# fi

