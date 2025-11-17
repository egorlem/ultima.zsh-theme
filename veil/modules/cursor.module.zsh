# Vail Сursor Module
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

typeset -g TERMINAL_CURSOR_VISIBLE=1

# ==============================================================================
# CORE CURSOR CONTROL FUNCTIONS
# ==============================================================================

# Скрыть курсор терминала с сохранением состояния
_terminalHideCursor() {
    printf '\033[?25l'  # ESC-последовательность скрытия курсора
    TERMINAL_CURSOR_VISIBLE=0
}

# Показать курсор терминала с сохранением состояния  
_terminalShowCursor() {
    printf '\033[?25h'  # ESC-последовательность показа курсора
    TERMINAL_CURSOR_VISIBLE=1
}

# Принудительное восстановление видимости курсора (страховка)
_terminalEnsureCursorVisible() {
    if (( ! TERMINAL_CURSOR_VISIBLE )); then
        _terminalShowCursor
    fi
}

# ==============================================================================
# MAIN CLEAR COMMAND HOOK
# ==============================================================================

clear() {
    _terminalHideCursor
    command clear
    _terminalScheduleCursorRestore
}

# ==============================================================================
# CURSOR RESTORATION SYSTEM
# ==============================================================================

_terminalScheduleCursorRestore() {
    precmd_functions=(${precmd_functions:#_terminalRestoreCursor})
    precmd_functions+=(_terminalRestoreCursor)
}

_terminalRestoreCursor() {
    _terminalShowCursor
    precmd_functions=(${precmd_functions:#_terminalRestoreCursor})
}

# ==============================================================================
# SAFETY AND ERROR RECOVERY SYSTEM
# ==============================================================================

_terminalEnsureCursorVisible

cursorFix() {
    _terminalEnsureCursorVisible
    echo "Cursor state reset"
}

# Диагностика текущего состояния курсора
cursorState() {
    if (( TERMINAL_CURSOR_VISIBLE )); then
        echo "Cursor: VISIBLE"
    else
        echo "Cursor: HIDDEN"
    fi
}