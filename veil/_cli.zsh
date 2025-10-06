# ultima.cli.zsh
# Ultima Zsh Core CLI - Standalone command line interface

__ultimaCliShowVersion() {
    echo "Ultima Zsh Core version: $ULTIMA_VERSION"
    if typeset -f ultimaVailVersion >/dev/null; then
        echo "Vail version: $(ultimaVailVersion)"
    else
        echo "Vail: version information not available"
    fi
}

__ultimaCliShowModules() {
    echo "Ultima Module Status:"
    echo "====================="
    
    local loaded_count=0
    local failed_count=0
    local total_count=0
    
    if [[ -n "$ULTIMA_MODULES" ]]; then
        for module in $ULTIMA_MODULES; do
            local status_func="ultima${(C)module}Status"
            if typeset -f "$status_func" >/dev/null; then
                # Исправленная строка: используем module_status вместо status
                local module_status=$($status_func 2>/dev/null)
                case "$module_status" in
                    "loaded")
                        echo "✓ $module: $module_status"
                        ((loaded_count++))
                        ;;
                    "failed")
                        echo "✗ $module: $module_status"
                        ((failed_count++))
                        ;;
                    *)
                        echo "? $module: unknown status"
                        ;;
                esac
            else
                echo "? $module: no status function"
            fi
            ((total_count++))
        done
    else
        echo "No modules configured"
    fi
    
    echo "====================="
    echo "Total: $loaded_count loaded, $failed_count failed of $total_count modules"
    
    if [[ $failed_count -gt 0 ]]; then
        return 1
    fi
    return 0
}

__ultimaCliShowPaths() {
    echo "Ultima Path Configuration:"
    echo "=========================="
    echo "Core Directory: $ULTIMA_DIR"
    echo "Default Modules: $ULTIMA_MODULES_DIR"
    
    if [[ -n "$ULTIMA_CUSTOM_MODULES_DIR" ]]; then
        echo "Custom Modules: $ULTIMA_CUSTOM_MODULES_DIR"
    else
        echo "Custom Modules: not configured"
    fi
    
    if [[ -n "$ULTIMA_CUSTOM_THEMES_DIR" ]]; then
        echo "Custom Themes: $ULTIMA_CUSTOM_THEMES_DIR"
    else
        echo "Custom Themes: not configured"
    fi
    
    echo "Themes Directory: $THEMES_DIR"
    echo "Current Theme: $THEME_NAME"
    
    echo ""
    echo "Available Module Files:"
    echo "----------------------"
    
    # Проверяем кастомные модули
    if [[ -n "$ULTIMA_CUSTOM_MODULES_DIR" && -d "$ULTIMA_CUSTOM_MODULES_DIR" ]]; then
        echo "Custom Modules:"
        local custom_modules=($ULTIMA_CUSTOM_MODULES_DIR/*.module.zsh(N))
        if [[ ${#custom_modules} -gt 0 ]]; then
            for module_file in $custom_modules; do
                local module_name="${module_file:t:r:r}"
                echo "  ○ $module_name"
            done
        else
            echo "  (no custom modules found)"
        fi
    fi
    
    # Проверяем стандартные модули
    if [[ -d "$ULTIMA_MODULES_DIR" ]]; then
        echo "Default Modules:"
        local default_modules=($ULTIMA_MODULES_DIR/*.module.zsh(N))
        if [[ ${#default_modules} -gt 0 ]]; then
            for module_file in $default_modules; do
                local module_name="${module_file:t:r:r}"
                echo "  ○ $module_name"
            done
        else
            echo "  (no default modules found)"
        fi
    fi
    
    echo ""
    echo "Available Theme Files:"
    echo "---------------------"
    local theme_files=($THEMES_DIR/*.zsh-theme(N))
    if [[ ${#theme_files} -gt 0 ]]; then
        for theme_file in $theme_files; do
            local theme_name="${theme_file:t:r}"
            if [[ "$theme_name" == "$THEME_NAME" ]]; then
                echo "  ★ $theme_name (active)"
            else
                echo "  ○ $theme_name"
            fi
        done
    else
        echo "  (no theme files found)"
    fi
}

__ultimaCliShowHelp() {
    cat << EOF
Ultima Zsh Core CLI - Management Utility

Usage: ultima [COMMAND]

Commands:
  -v, --version    Show Ultima and Vail version information
  -m, --modules    Show loaded modules and their status
  -p, --path       Show module paths and available modules/themes
  -h, --help       Show this help message

Examples:
  ultima --version
  ultima -m
  ultima --path

Environment Variables:
  ULTIMA_CUSTOM_MODULES_DIR  Custom modules directory
  ULTIMA_CUSTOM_THEMES_DIR   Custom themes directory  
  ULTIMA_MODULES             List of modules to load
  THEME_NAME                 Current theme name
EOF
}

# Основная функция CLI
ultima() {
    local command="$1"
    
    case "$command" in
        -v|--version)
            __ultimaCliShowVersion
            ;;
        -m|--modules)
            __ultimaCliShowModules
            ;;
        -p|--path)
            __ultimaCliShowPaths
            ;;
        -h|--help|"")
            __ultimaCliShowHelp
            ;;
        *)
            echo "Error: Unknown command '$command'" >&2
            echo ""
            __ultimaCliShowHelp
            return 1
            ;;
    esac
}

# Автодополнение для CLI
_ultima_cli_completion() {
    local state
    _arguments \
        '1: :->commands' \
        '*: :->args'
    
    case $state in
        commands)
            _values 'ultima commands' \
                '-v[Show version]' \
                '--version[Show version]' \
                '-m[Show modules]' \
                '--modules[Show modules]' \
                '-p[Show paths]' \
                '--path[Show paths]' \
                '-h[Show help]' \
                '--help[Show help]'
            ;;
    esac
}

compdef _ultima_cli_completion ultima

# Регистрируем что CLI загружен
ULTIMA_CLI_LOADED=1