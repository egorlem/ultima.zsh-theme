# Ultima Zsh Theme p3.c8 – https://github.com/egorlem/ultima.zsh-theme
#
# Yet Another Ultima
# 
# This project won't get you from point A to point B, but it will give you a 
# pleasant experience working in the terminal.
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
# INITIALIZATION
# ------------------------------------------------------------------------------

if [[ -n "$_ULTIMA_THEME_LOADED" ]]; then
  return 0
fi

typeset -gr _ULTIMA_THEME_LOADED=1

autoload -Uz add-zsh-hook

# ------------------------------------------------------------------------------
# CONSTANTS
# ------------------------------------------------------------------------------

# Box drawing characters for prompt design
typeset -gr _BOX_L="┌"      # Limiter corner (starts top line)    Unicode: \u250c
typeset -gr _BOX_P="└"      # Prompt corner (starts prompt line)  Unicode: \u2514
typeset -gr _BOX_H="─"      # Horizontal line (fills top limiter) Unicode: \u2500

typeset -g VCS="${VCS:-git}"
typeset -g ULTIMA_GIT_NO_UNTRACKED="${ULTIMA_GIT_NO_UNTRACKED:-0}" 

# Сache 
typeset -gi _U_CACHED_COLUMNS=0 
typeset -g _U_CACHED_SEPARATOR=""


# ------------------------------------------------------------------------------
# VCS SETUP FUNCTIONS
# ------------------------------------------------------------------------------

__ultimaSetupVCS() {
  # Validate VCS value
  if [[ "$VCS" != "git" && "$VCS" != "svn" && "$VCS" != "hg" ]]; then
    VCS=""
    return 1
  fi

  # Configuration
  local currentVCS="\":vcs_info:*\" enable $VCS"
  
  # Core prompt elements
  local badgeFormat="%F{0} on %f%F{0}›%f"                     # "on ›" separator
  local branchFormat="%F{2}%b%f"                          # Branch name in green
  local actionFormat="%F{0}%a %f%F{0}›%f"                   # Git action display

  # Git status indicators  
  local unstagedFormat="%F{6} M ›%f"                          # Unstaged changes
  local stagedFormat="%F{2} A ›%f"                              # Staged changes
  local hashFormat="%F{2}%6.6i%f %F{0}›%f"                   # Short commit hash

  if [[ $VCS != "" ]]; then
    autoload -Uz vcs_info || return 1
    eval zstyle $currentVCS
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
  fi

  case "$VCS" in 
    "git")
      if [[ "$ULTIMA_GIT_NO_UNTRACKED" != "1" ]]; then
        zstyle ':vcs_info:git*+set-message:*' hooks useGitUntracked
      fi
      zstyle ':vcs_info:git:*' stagedstr $stagedFormat
      zstyle ':vcs_info:git:*' unstagedstr $unstagedFormat
      zstyle ':vcs_info:git:*' actionformats "  ${actionFormat} ${hashFormat}%m%u%c${badgeFormat} ${branchFormat}"
      zstyle ':vcs_info:git:*' formats " %c%u%m${badgeFormat} ${branchFormat}"
      ;;
    "svn")
      zstyle ':vcs_info:svn:*' branchformat "%b"
      zstyle ':vcs_info:svn:*' formats " ${badgeFormat} ${branchFormat}"
      ;;
    "hg")
      zstyle ':vcs_info:hg:*' branchformat "%b"
      zstyle ':vcs_info:hg:*' formats " ${badgeFormat} ${branchFormat}"
      ;;
    *)
      return 1
      ;;
  esac

  return 0
}

# ------------------------------------------------------------------------------
# GIT HOOK FUNCTIONS
# ------------------------------------------------------------------------------

+vi-useGitUntracked() {
  local untrackedFormat="%F{4} U ›%f"                          # Untracked files

  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    if git status --porcelain=v1 2>/dev/null | grep -q "^??"; then
      hook_com[misc]=$untrackedFormat
      return 0
    fi
  fi

  hook_com[misc]=""
  return 1
}

# ------------------------------------------------------------------------------
# PROMPT HELPER FUNCTIONS
# ------------------------------------------------------------------------------

# SSH marker - shows "SSH:" when connected via SSH
__u_ssh() {
  if [[ -n "$SSH_CLIENT" || -n "$SSH2_CLIENT" ]]; then
    printf "%s" "%F{2}SSH%f%F{0}:%f"
    return 0
  fi
  return 1
}

# VCS status line - displays git/svn/hg information
__u_vcs() {
  if [[ -n "$VCS" ]]; then
    printf "%s" '${vcs_info_msg_0_}'
    return 0
  fi
  return 1
}

__ultimaBuildSeparator() {
  local width spacing="" i

  (( width = COLUMNS - 1 ))
  (( _U_CACHED_COLUMNS = COLUMNS ))

  (( width <= 0 )) && {
    _U_CACHED_SEPARATOR="${_BOX_L}"
    return 0
  }
  
  for (( i = 1; i <= width; i++ )); do
    spacing+=$_BOX_H
  done
  
  _U_CACHED_SEPARATOR="${_BOX_L}${spacing}"
  return 0
}

__u_separator() {
  if (( COLUMNS != _U_CACHED_COLUMNS )) || [[ -z "$_U_CACHED_SEPARATOR" ]]; then
    __ultimaBuildSeparator
  fi
  printf "%s" "$_U_CACHED_SEPARATOR"
}

# ------------------------------------------------------------------------------
# EXIT STATUS FUNCTION
# ------------------------------------------------------------------------------

# Exit status indicator
__ultimaExitStatus() {
  local lastStatus=$1
  
  if (( lastStatus != 0 )); then
    printf "%s" "%F{1}• ${lastStatus}%f"
  else
    printf "%s" "%F{2}•%f"
  fi
  return 0
}

# ------------------------------------------------------------------------------
# PROMPT DEFINITION
# ------------------------------------------------------------------------------

setopt PROMPT_SUBST
setopt TRANSIENT_RPROMPT

PROMPT="%F{0}$(__u_separator)
${_BOX_P} $(__u_ssh) %f%F{6}%~%f$(__u_vcs)
%F{2} ›%f "

RPROMPT=""

PS2="%F{0} %_ %f%F{6}› "
PS3=" › "

# ------------------------------------------------------------------------------
# HOOKS FUNCTIONS
# ------------------------------------------------------------------------------

__ultimaPrecmd() {
  local lastStatus=$?
  
  if [[ $VCS != "" ]]; then
    vcs_info
  fi

  # Set RPROMPT with exit status
  RPROMPT="$(__ultimaExitStatus "$lastStatus")"

  return 0
}

__ultimaSetupHooks() {
  add-zsh-hook precmd __ultimaPrecmd
  return 0
}

# ------------------------------------------------------------------------------
# MAIN EXECUTION
# ------------------------------------------------------------------------------

__ultimaSetupVCS

__ultimaSetupHooks

typeset -a _ULTIMA_CLEANUP_FUNCS=(
  __ultimaSetupVCS
  __ultimaSetupHooks
)

unset -f $_ULTIMA_CLEANUP_FUNCS
unset _ULTIMA_CLEANUP_FUNCS