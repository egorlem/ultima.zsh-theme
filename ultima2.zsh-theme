# Ultima Zsh Theme p3.c9 – XDG context integrated
#
# Yet Another Ultima
# ------------------------------------------------------------------------------
# License: WTFPL
# Authors: Egor Lem <guezwhoz@gmail.com>
# ------------------------------------------------------------------------------

if [[ -n "$_ULTIMA_THEME_LOADED" ]]; then
  return 0
fi

typeset -gr _ULTIMA_THEME_LOADED=1
autoload -Uz add-zsh-hook

# ------------------------------------------------------------------------------
# CONSTANTS
# ------------------------------------------------------------------------------
typeset -gr _BOX_L="┌"
typeset -gr _BOX_P="└"
typeset -gr _BOX_H="─"

typeset -g VCS="${VCS:-git}"
typeset -g ULTIMA_GIT_NO_UNTRACKED="${ULTIMA_GIT_NO_UNTRACKED:-0}" 

# Cache
typeset -gi _U_CACHED_COLUMNS=0 
typeset -g _U_CACHED_SEPARATOR=""

# XDG PATH CONTEXT
typeset -ga _U_XDG_KEYS=()
typeset -gA _U_XDG_PATHS=()
typeset -g _U_CACHED_PWD=""
typeset -g _U_PWD_CONTEXT=""

# ------------------------------------------------------------------------------
# XDG FUNCTIONS
# ------------------------------------------------------------------------------
__ultimaInitXDG() {
  local enabled keys key path

  # Feature toggle
  if zstyle -s ':ultima:xdg' enable enabled; then
    [[ "$enabled" != "yes" ]] && return 0
  fi

  # Ordered keys (fallback defaults)
  if ! zstyle -a ':ultima:xdg' keys keys; then
    keys=(
      XDG_CONFIG_HOME
      XDG_CACHE_HOME
      XDG_DATA_HOME
      XDG_STATE_HOME
      ZDOTDIR
    )
  fi
  _U_XDG_KEYS=("${keys[@]}")

  for key in $_U_XDG_KEYS; do
    if zstyle -s ':ultima:xdg' "$key" path; then
      :
    else
      path="${(P)key}"
    fi
    [[ -z "$path" ]] && continue
    path="${path:A}"
    path="${path%/}"
    _U_XDG_PATHS[$key]="$path"
  done
}

__ultimaResolvePWDContext() {
  local pwd key xdg_path format color

  pwd="${PWD:A}"
  pwd="${pwd%/}"

  # Cache hit
  [[ "$pwd" == "$_U_CACHED_PWD" ]] && return 0

  _U_CACHED_PWD="$pwd"
  _U_PWD_CONTEXT=""

  zstyle -s ':ultima:xdg' format format || format=' as %s'
  zstyle -s ':ultima:xdg' color  color  || color=5

  for key in $_U_XDG_KEYS; do
    xdg_path="${_U_XDG_PATHS[$key]}"
    [[ -z "$xdg_path" ]] && continue
    if [[ "$pwd" == "$xdg_path" || "$pwd" == "$xdg_path"/* ]]; then
      # store only the text; color applied in helper
      _U_PWD_CONTEXT="${format//%s/$key}"
      return 0
    fi
  done
}

__u_pwd_context() {
  local color
  zstyle -s ':ultima:xdg' color color || color=5
  [[ -n "$_U_PWD_CONTEXT" ]] && printf "%s" "%F{$color}$_U_PWD_CONTEXT%f"
}

# ------------------------------------------------------------------------------
# VCS SETUP FUNCTIONS
# ------------------------------------------------------------------------------
__ultimaSetupVCS() {
  if [[ "$VCS" != "git" && "$VCS" != "svn" && "$VCS" != "hg" ]]; then
    VCS=""
    return 1
  fi

  local currentVCS="\":vcs_info:*\" enable $VCS"
  local badgeFormat="%F{0} on %f%F{0}›%f"
  local branchFormat="%F{2}%b%f"
  local actionFormat="%F{0}%a %f%F{0}›%f"
  local unstagedFormat="%F{6} M ›%f"
  local stagedFormat="%F{2} A ›%f"
  local hashFormat="%F{2}%6.6i%f %F{0}›%f"

  if [[ $VCS != "" ]]; then
    autoload -Uz vcs_info || return 1
    eval zstyle $currentVCS
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
  fi

  case "$VCS" in 
    git)
      [[ "$ULTIMA_GIT_NO_UNTRACKED" != "1" ]] && zstyle ':vcs_info:git*+set-message:*' hooks useGitUntracked
      zstyle ':vcs_info:git:*' stagedstr $stagedFormat
      zstyle ':vcs_info:git:*' unstagedstr $unstagedFormat
      zstyle ':vcs_info:git:*' actionformats "  ${actionFormat} ${hashFormat}%m%u%c${badgeFormat} ${branchFormat}"
      zstyle ':vcs_info:git:*' formats " %c%u%m${badgeFormat} ${branchFormat}"
      ;;
    svn)
      zstyle ':vcs_info:svn:*' branchformat "%b"
      zstyle ':vcs_info:svn:*' formats " ${badgeFormat} ${branchFormat}"
      ;;
    hg)
      zstyle ':vcs_info:hg:*' branchformat "%b"
      zstyle ':vcs_info:hg:*' formats " ${badgeFormat} ${branchFormat}"
      ;;
    *)
      return 1
      ;;
  esac
}

# ------------------------------------------------------------------------------
# GIT HOOKS
# ------------------------------------------------------------------------------
+vi-useGitUntracked() {
  local untrackedFormat="%F{4} U ›%f"
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
# PROMPT HELPERS
# ------------------------------------------------------------------------------
__u_ssh() {
  if [[ -n "$SSH_CLIENT" || -n "$SSH2_CLIENT" ]]; then
    printf "%s" "%F{2}SSH%f%F{0}:%f"
  fi
}

__u_vcs() {
  [[ -n "$VCS" ]] && printf "%s" '${vcs_info_msg_0_}'
}

__ultimaBuildSeparator() {
  local width spacing="" i
  (( width = COLUMNS - 1 ))
  (( _U_CACHED_COLUMNS = COLUMNS ))
  (( width <= 0 )) && { _U_CACHED_SEPARATOR="${_BOX_L}"; return 0 }
  for (( i=1; i<=width; i++ )); do spacing+=$_BOX_H; done
  _U_CACHED_SEPARATOR="${_BOX_L}${spacing}"
}

__u_separator() {
  (( COLUMNS != _U_CACHED_COLUMNS || -z "$_U_CACHED_SEPARATOR" )) && __ultimaBuildSeparator
  printf "%s" "$_U_CACHED_SEPARATOR"
}

# ------------------------------------------------------------------------------
# EXIT STATUS
# ------------------------------------------------------------------------------
__ultimaExitStatus() {
  local lastStatus=$1
  if (( lastStatus != 0 )); then
    printf "%s" "%F{1}• ${lastStatus}%f"
  else
    printf "%s" "%F{2}•%f"
  fi
}

# ------------------------------------------------------------------------------
# PROMPT
# ------------------------------------------------------------------------------
setopt PROMPT_SUBST
setopt TRANSIENT_RPROMPT

PROMPT="%F{0}$(__u_separator)
${_BOX_P} $(__u_ssh) %f%F{6}%~%f$(__u_pwd_context)$(__u_vcs)
%F{2} ›%f "

RPROMPT=""
PS2="%F{0} %_ %f%F{6}› "
PS3=" › "

# ------------------------------------------------------------------------------
# HOOKS
# ------------------------------------------------------------------------------
__ultimaPrecmd() {
  local lastStatus=$?
  [[ $VCS != "" ]] && vcs_info
  __ultimaResolvePWDContext
  RPROMPT="$(__ultimaExitStatus "$lastStatus")"
}

__ultimaSetupHooks() {
  add-zsh-hook precmd __ultimaPrecmd
}

# ------------------------------------------------------------------------------
# MAIN EXECUTION
# ------------------------------------------------------------------------------
__ultimaSetupVCS
__ultimaInitXDG
__ultimaSetupHooks

typeset -a _ULTIMA_CLEANUP_FUNCS=( __ultimaSetupVCS __ultimaSetupHooks )
unset -f $_ULTIMA_CLEANUP_FUNCS
unset _ULTIMA_CLEANUP_FUNCS
