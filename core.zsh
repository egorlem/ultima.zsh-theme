# Ultima Zsh Core p3.c8 - https://github.com/egorlem/ultima.zsh-theme
#
# Core functionality and module system for Ultima Zsh theme
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Egor Lem <guezwhoz@gmail.com> / egorlem.com
#
# ------------------------------------------------------------------------------

# # ==============================================================================
# # LAZY LOADING
# # ==============================================================================

# autoload -Uz compinit
# if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
#   compinit
# else
#   compinit -C
# fi

# ==============================================================================
# CORE CONFIGURATION
# ==============================================================================

ULTIMA_VERSION="p3.c8"
ULTIMA_DIR="${0:A:h}"
ULTIMA_MODULES_DIR="$ULTIMA_DIR/modules"

# Поддержка кастомного пути к модулям
if [[ -z "$ULTIMA_CUSTOM_MODULES_DIR" ]]; then
    MODULES_DIR="$ULTIMA_MODULES_DIR"
else
    MODULES_DIR="$ULTIMA_CUSTOM_MODULES_DIR"
fi

# Поддержка кастомного списка модулей
if [[ -z "$ULTIMA_MODULES" ]]; then
    ULTIMA_MODULES=("less" "ls" "completion")
else
    # Разбиваем строку с модулями на массив (если передана как строка)
    ULTIMA_MODULES=(${(@s: :)ULTIMA_MODULES})
fi

# Поддержка кастомного пути к темам
if [[ -z "$ULTIMA_CUSTOM_THEMES_DIR" ]]; then
    THEMES_DIR="$ULTIMA_DIR"
else
    THEMES_DIR="$ULTIMA_CUSTOM_THEMES_DIR"
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

# Graphic characters for consistent UI
CHAR_ARROW="›"                                                 # Unicode: \u203a
CHAR_UP_AND_RIGHT_DIVIDER="└"                                  # Unicode: \u2514  
CHAR_DOWN_AND_RIGHT_DIVIDER="┌"                                # Unicode: \u250c
CHAR_VERTICAL_DIVIDER="─"                                      # Unicode: \u2500

# ANSI color codes
ANSI_RESET="\x1b[0m"
ANSI_DIM_BLACK="\x1b[0;30m"

# ==============================================================================
# MODULE SYSTEM
# ==============================================================================

ultimaLoadModule() {
  local module_file="$MODULES_DIR/$1.zsh"
  if [[ -f "$module_file" ]]; then
    source "$module_file"
  else
    echo "Ultima: module $1 not found at $module_file"
  fi
}

ultimaLoadTheme() {
  local THEME_FILE="$THEMES_DIR/${THEME_NAME}.zsh-theme"
    
  # Проверяем существование файла темы
  if [[ ! -f "$THEME_FILE" ]]; then
      echo "Ultima: error - theme file not found: $THEME_FILE" >&2
      return 1
  fi
  
  # Проверяем возможность чтения файла
  if [[ ! -r "$THEME_FILE" ]]; then
      echo "Ultima: error - cannot read theme file: $THEME_FILE" >&2
      return 1
  fi
  
  # Загружаем тему
  if source "$THEME_FILE"; then
      [[ -n "$ULTIMA_VERBOSE" ]] && echo "Ultima: theme '$THEME_NAME' loaded successfully"
      return 0
  else
      echo "Ultima: error - failed to load theme '$THEME_NAME'" >&2
      return 1
  fi
}

# Load modules if available
if [[ -d "$MODULES_DIR" ]]; then
  for module in $ULTIMA_MODULES; do
    ultimaLoadModule "$module"
  done
else
  echo "Ultima: running in minimal mode without modules"
fi

ULTIMA_CORE_LOADED=1

# Load theme
if ! ultimaLoadTheme; then
    echo "Ultima: warning - theme loading failed, continuing without theme" >&2
fi

