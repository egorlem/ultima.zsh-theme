# test-theme.zsh-theme
# Simple test theme for Vail
#
# Usage: export THEME_NAME="test-theme" before loading ultima.zsh

# ==============================================================================
# PROMPT VARIABLES
# ==============================================================================

# Simple colors and characters for testing
TEST_ARROW="➤"
TEST_SUCCESS="✅"
TEST_ERROR="❌"
TEST_FOLDER="📁"

# ==============================================================================
# PROMPT CONFIGURATION
# ==============================================================================

setopt PROMPT_SUBST

# Simple function to show exit status
test_exit_status() {
    if [[ $? -eq 0 ]]; then
        echo "%F{green}$TEST_SUCCESS%f"
    else
        echo "%F{red}$TEST_ERROR%f"
    fi
}

# Simple function to show current directory
test_current_dir() {
    echo "%F{blue}$TEST_FOLDER %~%f"
}

# ==============================================================================
# PROMPT DEFINITION
# ==============================================================================

# Simple one-line prompt
PROMPT='$(test_exit_status) $(test_current_dir)
%F{cyan}$TEST_ARROW%f '

# No right prompt
RPROMPT=''

# Simple continuation prompt
PS2='%F{yellow}... %f'

# ==============================================================================
# HOOKS (optional)
# ==============================================================================

precmd() {
    # Update terminal title
    print -Pn "\e]0;Test Theme: %~\a"
}

preexec() {
    # Show command in terminal title
    print -Pn "\e]0;Test Theme: $1\a"
}