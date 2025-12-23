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

if [[ -n "$ULTIMA_THEME_LOADED" ]]; then
  return 0
fi

typeset -gr ULTIMA_THEME_LOADED=1

autoload -Uz add-zsh-hook

# ------------------------------------------------------------------------------
# CONSTANTS
# ------------------------------------------------------------------------------

# Box drawing characters for prompt design
typeset -gr BOX_L="┌"      # Limiter corner (starts top line)    Unicode: \u250c
typeset -gr BOX_P="└"      # Prompt corner (starts prompt line)  Unicode: \u2514
typeset -gr BOX_H="─"      # Horizontal line (fills top limiter) Unicode: \u2500

typeset -gr SCI_RST="\x1b[0m"                              #   SGR 0 - Reset all
typeset -gr SCI_BLACK="\x1b[0;30m"                         # SGR 0;30 - black FG

typeset -g VCS="${VCS:-git}"
typeset -g ULTIMA_GIT_NO_UNTRACKED="${ULTIMA_GIT_NO_UNTRACKED:-0}" 

# Сache 
typeset -gi U_CACHED_COLUMNS=0 
typeset -g U_CACHED_SEPARATOR=""


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
  local branchFormat="%F{85}%b%f"                         # Branch name in green
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
    echo "%F{2}SSH%f%F{0}:%f"
    return 0
  fi
  return 1
}

# VCS status line - displays git/svn/hg information
__u_vcs() {
  if [[ -n "$VCS" ]]; then
    echo '${vcs_info_msg_0_}'
    return 0
  fi
  return 1
}

__ultimaBuildSeparator() {
  local width spacing="" i

  (( width = COLUMNS - 1 ))
  (( U_CACHED_COLUMNS = COLUMNS ))

  (( width <= 0 )) && {
    U_CACHED_SEPARATOR="${SCI_BLACK}${BOX_L}${SCI_RST}"
    return 0
  }
  
  for (( i = 1; i <= width; i++ )); do
    spacing+=$BOX_H
  done
  
  U_CACHED_SEPARATOR="${SCI_BLACK}${BOX_L}${spacing}${SCI_RST}"
  return 0
}

__ultimaPrintSeparator() {
  if (( COLUMNS != U_CACHED_COLUMNS )) || [[ -z "$U_CACHED_SEPARATOR" ]]; then
    __ultimaBuildSeparator
  fi
  
  echo "$U_CACHED_SEPARATOR"
  return 0
}

# ------------------------------------------------------------------------------
# PROMPT DEFINITION
# ------------------------------------------------------------------------------

setopt PROMPT_SUBST

PROMPT="%F{0}${BOX_P} $(__u_ssh) %f%F{6}%~%f$(__u_vcs)
%F{2} ›%f "

RPROMPT=""

PS2="%F{0} %_ %f%F{6}› "
PS3=" › "

# ------------------------------------------------------------------------------
# HOOKS FUNCTIONS
# ------------------------------------------------------------------------------

# Called before each prompt display
# Updates VCS info and draws the top separator line
__ultimaPrecmd() {
  if [[ $VCS != "" ]]; then
    vcs_info || return 1
  fi
  __ultimaPrintSeparator
  return 0
}

# Sets up zsh hooks for prompt functionality
__ultimaSetupHooks() {
  add-zsh-hook precmd __ultimaPrecmd || return 1
  return 0
}

# ------------------------------------------------------------------------------
# MAIN EXECUTION
# ------------------------------------------------------------------------------

__ultimaSetupVCS

__ultimaSetupHooks

# Cleanup setup functions (no longer needed after execution)
unset __ultimaSetupVCS __ultimaSetupHooks 