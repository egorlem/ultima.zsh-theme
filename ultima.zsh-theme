# Ultima Zsh Theme p3.c8 - https://github.com/egorlem/ultima.zsh-theme
#
# Yet another Ultima
# 
# This project won't get you from point A to point B, but it will give you a 
# pleasant experience working in the terminal.
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Egor Lem <guezwhoz@gmail.com> / egorlem.com
#
# ------------------------------------------------------------------------------

if [[ -n "$ULTIMA_THEME_LOADED" ]]; then
    return 0
fi

ULTIMA_THEME_LOADED=1

# ==============================================================================
# INITIALIZATION
# ==============================================================================

autoload -Uz add-zsh-hook

# ==============================================================================
# PROMPT VARIABLES
# ==============================================================================

if [[ -z "$VCS" ]]; then
    VCS="git"
fi

CHAR_ARROW="›"                                                 # Unicode: \u203a
CHAR_UP_AND_RIGHT_DIVIDER="└"                                  # Unicode: \u2514  
CHAR_DOWN_AND_RIGHT_DIVIDER="┌"                                # Unicode: \u250c
CHAR_VERTICAL_DIVIDER="─"                                      # Unicode: \u2500

ANSI_RESET="\x1b[0m"
ANSI_DIM_BLACK="\x1b[0;30m"

CHAR_BADGE="%F{black} on %f%F{black}${CHAR_ARROW}%f"
VC_BRANCH_NAME="%F{green}%b%f"
VC_ACTION="%F{black}%a %f%F{black}${CHAR_ARROW}%f"
VC_UNSTAGED_STATUS="%F{cyan} M ${CHAR_ARROW}%f"
VC_GIT_STAGED_STATUS="%F{green} A ${CHAR_ARROW}%f"
VC_GIT_HASH="%F{green}%6.6i%f %F{black}${CHAR_ARROW}%f"
VC_GIT_UNTRACKED_STATUS="%F{blue} U ${CHAR_ARROW}%f"

CURRENT_VCS="\":vcs_info:*\" enable $VCS"

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

_printPsOneLimiter() {
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

_ultimaPrecmd() {
  [[ $VCS != "" ]] && vcs_info
  _printPsOneLimiter
}

_ultimaSetupHooks() {
  add-zsh-hook precmd _ultimaPrecmd
}

_ultimaSetupHooks
unset _ultimaSetupHooks

echo 'ultima loaded'