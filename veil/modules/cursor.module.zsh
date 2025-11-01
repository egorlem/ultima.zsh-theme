# Veil Cursor Module
# cursor.module.zsh

# typeset -g ULTIMA_CURSOR_INITIALIZED=0

# # ==============================================================================
# # CORE CURSOR CONTROL (internal)
# # ==============================================================================

# __ultimaCursorHide() {
#     printf '\033[?25l'
# }

# __ultimaCursorShow() {
#     printf '\033[?25h' 
# }

# __ultimaCursorSafetyEnsure() {
#     __ultimaCursorShow
# }

# # ==============================================================================
# # CLEAR COMMAND HOOK (internal)
# # ==============================================================================

# __ultimaClearWithCursor() {
#     __ultimaCursorHide
#     command clear
#     __ultimaCursorShow
# }

# __ultimaSetupClearHook() {
#     alias clear='__ultimaClearWithCursor'
# }

# # ==============================================================================
# # MODULE API (public)
# # ==============================================================================

# ultimaCursorInit() {
#     [[ $ULTIMA_CURSOR_INITIALIZED -eq 1 ]] && return 0
    
#     __ultimaSetupClearHook
    
#     autoload -Uz add-zsh-hook
#     add-zsh-hook zshexit __ultimaCursorSafetyEnsure
    
#     ULTIMA_CURSOR_INITIALIZED=1
#     return 0
# }


# ==============================================================================
# DUAL-MODE LOADING
# ==============================================================================

# [[ -z "$ULTIMA_CORE_LOADED" ]] && ultimaCursorInit


# Автоинициализация с обработкой ошибок
# if [[ -z "$ULTIMA_CORE_LOADED" ]]; then
#   if ! ultimaCursorInit; then
#     echo "Ultima: critical - clear module failed to load" >&2
#   fi
# fi  





# ------------------------------------------------------------------------------


# ==============================================================================
# TERMINAL CURSOR MANAGEMENT HOOK
# Production-ready clear command with cursor control
# 
# PURPOSE:
#   Перехватывает команду 'clear', обеспечивая плавное скрытие и восстановление
#   курсора для создания эффекта ретро-терминала эпохи DMBDM.
#
# MECHANISM:
#   1. При вызове 'clear' курсор скрывается перед очисткой экрана
#   2. После выполнения очистки и отрисовки промпта курсор автоматически
#      восстанавливается через precmd hook system ZSH
#   3. Гарантированное восстановление курсора при выходе из shell/прерываниях
#
# ARCHITECTURE:
#   clear() → _terminal_hide_cursor() → command clear → _terminal_schedule_cursor_restore()
#   ↓
#   precmd_functions → _terminal_restore_cursor() → _terminal_show_cursor()
#
# SAFETY FEATURES:
#   - Отслеживание состояния курсора (TERMINAL_CURSOR_VISIBLE)
#   - Восстановление при сигналах (Ctrl+C, TERM)
#   - Аварийные команды cursor-fix и cursor-state
#   - Самоочистка хуков для предотвращения накопления
# ==============================================================================

# Глобальная переменная отслеживания состояния курсора (1 = видим, 0 = скрыт)
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

# Перехваченная команда clear с управлением курсором
clear() {
    # Фаза 1: Скрытие курсора перед очисткой
    _terminalHideCursor
    
    # Фаза 2: Выполнение настоящей команды очистки
    command clear
    
    # Фаза 3: Планирование восстановления курсора после отрисовки промпта
    _terminalScheduleCursorRestore
}

# ==============================================================================
# CURSOR RESTORATION SYSTEM
# ==============================================================================

# Планирование восстановления курсора через систему хуков ZSH
_terminalScheduleCursorRestore() {
    # Очистка предыдущих регистраций во избежание дублирования
    precmd_functions=(${precmd_functions:#_terminalRestoreCursor})
    # Регистрация функции восстановления в хуках pre-command
    precmd_functions+=(_terminalRestoreCursor)
}

# Функция восстановления курсора (вызывается системой ZSH перед промптом)
_terminalRestoreCursor() {
    # Восстановление видимости курсора
    _terminalShowCursor
    # Самоочистка: удаление себя из очереди хуков
    precmd_functions=(${precmd_functions:#_terminalRestoreCursor})
}

# ==============================================================================
# SAFETY AND ERROR RECOVERY SYSTEM
# ==============================================================================

# Инициализация: гарантия видимого курсора при запуске shell
_terminalEnsureCursorVisible

# Хук выхода из shell: гарантия восстановления курсора
# zshexit() {
#     _terminalEnsureCursorVisible
# }

# Обработка прерываний (Ctrl+C): восстановление курсора
# TRAPINT() {
#     _terminalEnsureCursorVisible
#     return $(( 128 + $1 ))
# }

# TRAPINT() {
#     # Принудительно перерисовать промпт
#     zle && { zle reset-prompt 2>/dev/null || true; }
    
#     # Ваш существующий код (если есть)
#     # _terminalEnsureCursorVisible
    
#     return $(( 128 + $1 ))
# }

# # Обработка сигнала завершения: восстановление курсора
# TRAPTERM() {
#     _terminalEnsureCursorVisible
#     return $(( 128 + $1 ))
# }

# ==============================================================================
# DIAGNOSTIC AND MAINTENANCE COMMANDS
# ==============================================================================

# Аварийное восстановление курсора (если система дала сбой)
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