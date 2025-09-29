# Ultima Zsh Theme p2.c8 - https://github.com/egorlem/ultima.zsh-theme
#
# Minimalistic .zshrc config contains all of the settings required for 
# comfortable terminal use.
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Egor Lem <guezwhoz@gmail.com> / egorlem.com
#
# ------------------------------------------------------------------------------

# ==============================================================================
# LAZY LOADING
# ==============================================================================

autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# ==============================================================================
# CORE CONFIGURATION
# ==============================================================================

ULTIMA_VERSION="p2.c8"
ULTIMA_DIR="${0:A:h}"
ULTIMA_MODULES_DIR="$ULTIMA_DIR/modules"
ULTIMA_MODULES=("less" "ls" "completion")

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
  local module_file="$ULTIMA_MODULES_DIR/$1.zsh"
  if [[ -f "$module_file" ]]; then
    source "$module_file"
  else
    echo "Ultima: module $1 not found at $module_file"
  fi
}

# Load modules if available
if [[ -d "$ULTIMA_MODULES_DIR" ]]; then
  for module in $ULTIMA_MODULES; do
    ultimaLoadModule "$module"
  done
else
  echo "Ultima: running in minimal mode without modules"
fi

ULTIMA_CORE_LOADED=1

# ==============================================================================
# PROMPT CONFIGURATION
# ==============================================================================

export VCS="git"

# VCS Info setup
CURRENT_VCS="\":vcs_info:*\" enable $VCS"
CHAR_BADGE="%F{black} on %f%F{black}${CHAR_ARROW}%f"
VC_BRANCH_NAME="%F{green}%b%f"

VC_ACTION="%F{black}%a %f%F{black}${CHAR_ARROW}%f"
VC_UNSTAGED_STATUS="%F{cyan} M ${CHAR_ARROW}%f"
VC_GIT_STAGED_STATUS="%F{green} A ${CHAR_ARROW}%f"
VC_GIT_HASH="%F{green}%6.6i%f %F{black}${CHAR_ARROW}%f"
VC_GIT_UNTRACKED_STATUS="%F{blue} U ${CHAR_ARROW}%f"

if [[ $VCS != "" ]]; then
  autoload -Uz vcs_info
  eval zstyle $CURRENT_VCS
  zstyle ':vcs_info:*' get-revision true
  zstyle ':vcs_info:*' check-for-changes true
fi

case "$VCS" in 
  "git")
    zstyle ':vcs_info:git*+set-message:*' hooks useGitUntracked
    zstyle ':vcs_info:git:*' stagedstr $VC_GIT_STAGED_STATUS
    zstyle ':vcs_info:git:*' unstagedstr $VC_UNSTAGED_STATUS
    zstyle ':vcs_info:git:*' actionformats "  ${VC_ACTION} ${VC_GIT_HASH}%m%u%c${CHAR_BADGE} ${VC_BRANCH_NAME}"
    zstyle ':vcs_info:git:*' formats " %c%u%m${CHAR_BADGE} ${VC_BRANCH_NAME}"
    ;;
  "svn")
    zstyle ':vcs_info:svn:*' branchformat "%b"
    zstyle ':vcs_info:svn:*' formats " ${CHAR_BADGE} ${VC_BRANCH_NAME}"
    ;;
  "hg")
    zstyle ':vcs_info:hg:*' branchformat "%b"
    zstyle ':vcs_info:hg:*' formats " ${CHAR_BADGE} ${VC_BRANCH_NAME}"
    ;;
esac

+vi-useGitUntracked() {
  if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == "true" ]] &&
    git status --porcelain | grep -m 1 "^??" &>/dev/null; then
    hook_com[misc]=$VC_GIT_UNTRACKED_STATUS
  else
    hook_com[misc]=""
  fi
}

# SSH indicator
SSH_MARKER=""
[[ -n "$SSH_CLIENT" || -n "$SSH2_CLIENT" ]] && SSH_MARKER="%F{green}SSH%f%F{black}:%f"

# ==============================================================================
# PROMPT DEFINITION
# ==============================================================================

setopt PROMPT_SUBST

prepareGitStatusLine() {
  echo '${vcs_info_msg_0_}'
} 

printPsOneLimiter() {
  local termwidth spacing=""
  ((termwidth = ${COLUMNS} - 1))
  for i in {1..$termwidth}; do
    spacing="${spacing}${CHAR_VERTICAL_DIVIDER}"
  done
  echo $ANSI_DIM_BLACK$CHAR_DOWN_AND_RIGHT_DIVIDER$spacing$ANSI_RESET
}

PROMPT="%F{black}${CHAR_UP_AND_RIGHT_DIVIDER} ${SSH_MARKER} %f%F{cyan}%~%f$(prepareGitStatusLine)
%F{green} ${CHAR_ARROW}%f "

RPROMPT=""
PS2="%F{black} %_ %f%F{cyan}${CHAR_ARROW} "
PS3=" ${CHAR_ARROW} "

# ==============================================================================
# HOOKS
# ==============================================================================

precmd() {
  [[ $VCS != "" ]] && vcs_info
  printPsOneLimiter
} 
