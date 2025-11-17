# Veil — https://github.com/egorlem/ultima.zsh-theme/tree/main/vail
#
# Modular Z Shell Configuration System
# Takes full control of zsh configuration through logical modules
# ------------------------------------------------------------------------------
# License: WTFPL – https://github.com/egorlem/ultima.zsh-theme/blob/main/LICENSE 
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Egor Lem <guezwhoz@gmail.com> / egorlem.com
#
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CORE CONFIGURATION
# ------------------------------------------------------------------------------

if [[ -n "$VEIL_CORE_LOADED" ]]; then
    return 0
fi

VEIL_DIR="${0:A:h}"
DEFAULT_VEIL_MODULES_DIR="$VEIL_DIR/veil/modules"

# Support for custom modules path
if [[ -z "$VEIL_MODULES_DIR" ]]; then
    MODULES_DIR="$DEFAULT_VEIL_MODULES_DIR"
else
    MODULES_DIR="$VEIL_MODULES_DIR"
fi

# Support for custom modules list
if [[ -z "$VEIL_MODULES" ]]; then
    VEIL_MODULES=("less" "ls" "completion")
else
    # Split modules string into array (if passed as string)
    VEIL_MODULES=(${(@s: :)VEIL_MODULES})
fi

# Remove duplicate modules
typeset -U VEIL_MODULES

# Check for empty modules array
if [[ ${#VEIL_MODULES[@]} -eq 0 ]]; then
    echo "Veil: warning - no modules specified" >&2
fi

# Support for custom themes path
if [[ -z "$VEIL_THEMES_DIR" ]]; then
    THEMES_DIR="$VEIL_DIR"
else
    THEMES_DIR="$VEIL_THEMES_DIR"
fi

# Default theme name
if [[ -z "$THEME" ]]; then
    THEME="ultima"
fi

# ------------------------------------------------------------------------------
# SHARED VARIABLES (available to all modules)
# ------------------------------------------------------------------------------

# Color schemes for LS and completion
LSCOLORS="gxafexdxfxagadabagacad"                                                                   # BSD
LS_COLORS="di=36:ln=30;45:so=34:pi=33:ex=35:bd=30;46:cd=30;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"  # GNU
export LSCOLORS LS_COLORS

# ------------------------------------------------------------------------------
# MODULE SYSTEM
# ------------------------------------------------------------------------------

# Associative array to track loaded modules
typeset -gA VEIL_MODULE_LOADED

_veilLoadModule() {
  local module_file="$MODULES_DIR/$1.module.zsh"
  
  # Check if module file exists
  if [[ ! -f "$module_file" ]]; then
    [[ -n "$VEIL_VERBOSE" ]] && echo "Veil: module $1 not found at $module_file" >&2
    return 1
  fi
  
  # Check if module file is readable
  if [[ ! -r "$module_file" ]]; then
    [[ -n "$VEIL_VERBOSE" ]] && echo "Veil: cannot read module $1" >&2
    return 1
  fi
  
  # Check if module is already loaded
  if [[ -n "${VEIL_MODULE_LOADED[$1]}" ]]; then
    [[ -n "$VEIL_VERBOSE" ]] && echo "Veil: module '$1' already loaded" >&2
    return 0
  fi
  
  # Load module
  if source "$module_file"; then
    VEIL_MODULE_LOADED[$1]=1
    [[ -n "$VEIL_VERBOSE" ]] && echo "Veil: module '$1' loaded successfully"
    return 0
  else
    echo "Veil: failed to load module '$1'" >&2
    return 1
  fi
}

_veilLoadTheme() {
  local THEME_FILE="$THEMES_DIR/${THEME}.zsh-theme"
    
  # Check if theme file exists
  if [[ ! -f "$THEME_FILE" ]]; then
      [[ -n "$VEIL_VERBOSE" ]] && echo "Veil: error - theme file not found: $THEME_FILE" >&2
      return 1
  fi
  
  # Check if theme file is readable
  if [[ ! -r "$THEME_FILE" ]]; then
      [[ -n "$VEIL_VERBOSE" ]] && echo "Veil: error - cannot read theme file: $THEME_FILE" >&2
      return 1
  fi
  
  # Load theme
  if source "$THEME_FILE"; then
      [[ -n "$VEIL_VERBOSE" ]] && echo "Veil: theme '$THEME' loaded successfully"
      return 0
  else
      [[ -n "$VEIL_VERBOSE" ]] && echo "Veil: error - failed to load theme '$THEME'" >&2
      return 1
  fi
}

# Load modules if available
if [[ -d "$MODULES_DIR" ]]; then
  for module in $VEIL_MODULES; do
    _veilLoadModule "$module"
  done
else
  [[ -n "$VEIL_VERBOSE" ]] && echo "Veil: running in minimal mode without modules" >&2
fi

VEIL_CORE_LOADED=1

# Load theme
if ! _veilLoadTheme; then
    [[ -n "$VEIL_VERBOSE" ]] && echo "Veil: warning - theme loading failed, continuing without theme" >&2
fi