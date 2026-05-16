# Ultima Zsh Theme p3.c9 – https://github.com/egorlem/ultima.zsh-theme
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

[[ -n "$_U_FILE_GUARD" ]] && return
typeset -gr _U_FILE_GUARD=1

# CONSTANTS --------------------------------------------------------------------

typeset -g ULTIMA_VCS="${ULTIMA_VCS:-git}"
typeset -g ULTIMA_VCS_NO_UNTRACKED="${ULTIMA_VCS_NO_UNTRACKED:-1}"
typeset -g ULTIMA_PATH_ANNOTATION="${ULTIMA_PATH_ANNOTATION:-0}"

typeset -gi _U_INIT_GUARD=0

typeset -gi _U_SEP_CACHED_WIDTH=0
typeset -g  _U_SEP_CACHED_LINE=""
typeset -gA _U_SEGMENTS=(
  ssh __seg_ssh
  dir __seg_dir
  xdg __seg_xdg
  vcs __seg_vcs
)

typeset -ga _U_XDG_KEYS=()
typeset -gA _U_XDG_PATHS=()
typeset -g _U_CACHED_PWD=""
typeset -g _U_XDG_INFO=""

# SEGMENTS ---------------------------------------------------------------------

__seg_ssh() {
  [[ -n "$SSH_CLIENT" || -n "$SSH2_CLIENT" ]] && echo "%F{2}SSH%f%F{0}:%f"
}

__seg_dir() {
  echo "%F{6}%~%f"
}

__seg_xdg() {
  local pwd="${PWD:A}"
  pwd="${pwd%/}"

  if [[ "$pwd" == "$_U_CACHED_PWD" ]]; then
    [[ -n "$_U_XDG_INFO" ]] && echo "$_U_XDG_INFO"
    return
  fi

  _U_CACHED_PWD="$pwd"
  _U_XDG_INFO=""

  local key xdgPath

  for key in $_U_XDG_KEYS; do
    xdgPath="${_U_XDG_PATHS[$key]}"
    [[ -z "$xdgPath" ]] && continue

    if [[ "$pwd" == "$xdgPath" || "$pwd" == "$xdgPath"/* ]]; then
      _U_XDG_INFO="%F{0}as %F{2}${key}%f"
      break
    fi
  done

  [[ -n "$_U_XDG_INFO" ]] && echo "$_U_XDG_INFO"
}

__seg_vcs() {
  [[ -n "$vcs_info_msg_0_" ]] && echo "$vcs_info_msg_0_"
}

__seg_status() {
  local sc=$1

  if (( sc == 0 )); then
    echo "%F{2}•%f"
  else
    echo "%F{1}• $sc%f"
  fi
}

__seg_prompt_arrow() {
  echo "%F{2} ›%f "
}

# XDG --------------------------------------------------------------------------

__ultimaSetupXDG() {
  local keys key path

  keys=(
    XDG_CONFIG_HOME
    XDG_CACHE_HOME
    XDG_DATA_HOME
    XDG_STATE_HOME
    ZDOTDIR
  )

  _U_XDG_KEYS=("${keys[@]}")

  for key in $_U_XDG_KEYS; do
    path="${(P)key}"
    
    [[ -z "$path" ]] && continue

    path="${path:A}"
    path="${path%/}"

    _U_XDG_PATHS[$key]="$path"
  done
}

# VCS --------------------------------------------------------------------------

__ultimaSetupVCS() {
  autoload -Uz vcs_info || return 1

  local badge="%F{0} on %f%F{0}›%f"                           # "on ›" separator
  local branch="%F{2}%b%f"                                # Branch name in green
  local action=" %F{0}%a %f%F{0}›%f"                        # Git action display
  local hash="%F{2}%6.6i%f %F{0}›%f"                         # Short commit hash

  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' get-revision true
  zstyle ':vcs_info:*' check-for-changes true

  zstyle ':vcs_info:git:*' stagedstr "%F{2} A ›%f"
  zstyle ':vcs_info:git:*' unstagedstr "%F{6} M ›%f"

  zstyle ':vcs_info:git:*' formats "%c%u%m${badge} ${branch}"
  zstyle ':vcs_info:git:*' actionformats "${action} ${hash}%m%u%c${badge} ${branch}"

  if [[ "$ULTIMA_VCS_NO_UNTRACKED" != "0" ]]; then 
    zstyle ':vcs_info:git*+set-message:*' hooks useGitUntracked
  fi
}

+vi-useGitUntracked() {
  git rev-parse --is-inside-work-tree &>/dev/null || return 1

  if git ls-files --others --exclude-standard -z | read -r -d '' _; then
    hook_com[misc]="%F{4} U ›%f"
  fi
}

# SEGMENT BUILDER --------------------------------------------------------------

__ultimaBuildLine() {
  local -a keys=("$@")
  local -a out=()
  local key fn val

  for key in "${keys[@]}"; do
    fn="${_U_SEGMENTS[$key]}"

    [[ -z "$fn" ]] && continue
    (( $+functions[$fn] )) || continue

    val="$($fn 2>/dev/null)"
    [[ -n "$val" ]] && out+=("$val")
  done

  echo "${(j: :)out}"
}

# HELPERS ----------------------------------------------------------------------

__ultimaSeparator() {
  local width=$(( COLUMNS - 1 ))

  if (( width != _U_SEP_CACHED_WIDTH )); then
    _U_SEP_CACHED_WIDTH=$width

    local line=""
    local i

    for (( i = 0; i < width; i++ )); do
      line+="─"
    done

    _U_SEP_CACHED_LINE="%F{0}┌${line}%f"
  fi

  echo "$_U_SEP_CACHED_LINE"
}

# PROMPT -----------------------------------------------------------------------

__ultimaPrecmd() {
  # return status code
  local sc=$?

  local -a segs=(ssh dir)

  if [[ $ULTIMA_PATH_ANNOTATION != "0" ]]; then 
    segs+=(xdg)
  fi

  if [[ "$ULTIMA_VCS" == "git" ]]; then
    vcs_info
    segs+=(vcs)
  fi

  local line1 line2
  
  line1=$(__ultimaSeparator)
  line2=$(__ultimaBuildLine "${segs[@]}")

  local promptLines=(
    "$line1"
    "%F{0}└%f  $line2"
    "$(__seg_prompt_arrow)"
  )

  PROMPT="${(F)promptLines}"
  RPROMPT="$(__seg_status "$sc")"
}

# INIT -------------------------------------------------------------------------

prompt_ultima_setup() {
  (( _U_INIT_GUARD )) && return 
  _U_INIT_GUARD=1

  autoload -Uz add-zsh-hook
  setopt TRANSIENT_RPROMPT

  if [[ "$ULTIMA_VCS" == "git" ]]; then
    __ultimaSetupVCS
  fi

  if [[ "$ULTIMA_PATH_ANNOTATION" != "0" ]]; then
    __ultimaSetupXDG
  fi

  add-zsh-hook precmd __ultimaPrecmd

  PS2="%F{0} %_ %f%F{6}› "
  PS3=" › "
}

prompt_ultima_setup "$@"