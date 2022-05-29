# 021011 zsh theme v1.2.0 - https://github.com/guesswhozzz/021011.zsh-theme

autoload -Uz compinit 
autoload -Uz vcs_info
compinit

# ANSI VARIABLES =============================================================== 

local ANSI_reset="\x1B[0m"
local ANSI_dim_black="\x1B[38;05;236m"

# GRAPHICS VARIABLES ===========================================================

local char_arrow="›"                                            #Unicode: \u203a
local char_up_and_right_divider="└"                             #Unicode: \u2514
local char_down_and_right_divider="┌"                           #Unicode: \u250c
local char_vertical_divider="─"                                 #Unicode: \u2500

# VCS STATUS LINE ==============================================================
export VCS="git"

local current_vcs="\":vcs_info:*\" enable $VCS"
local char_badge="%F{238} 𝗈𝗇 %f%F{236}${char_arrow}%f"
local vc_branch_name="%F{85}%b%f"

local vc_action="%F{238}%a %f%F{236}${char_arrow}%f"
local vc_unstaged_status="%F{80} M ${char_arrow}%f"

local vc_git_staged_status="%F{115} A ${char_arrow}%f"
local vc_git_hash="%F{151}%6.6i%f %F{236}${char_arrow}%f"
local vc_git_untracked_status="%F{74} U ${char_arrow}%f"

# vcs_info_printsys list off suported vcs backends
# vcs_info_lastmsg display formated message

if [[ $VCS != "" ]]; then
  echo "ставим базовые переменные для vcs_info"
  autoload -Uz vcs_info
  eval zstyle $current_vcs
  zstyle ":vcs_info:*" get-revision true
  zstyle ":vcs_info:*" check-for-changes true
fi

case "$VCS" in 
   "git")
    # git sepecific 
# git sepecific 
    # git sepecific 
    echo "ставим git переменные для vcs_info"
    zstyle ":vcs_info:git*+set-message:*" hooks use_git_untracked
    zstyle ":vcs_info:git:*" stagedstr $vc_git_staged_status
    zstyle ":vcs_info:git:*" unstagedstr $vc_unstaged_status
    zstyle ":vcs_info:git:*" actionformats "  ${vc_action} ${vc_git_hash}%m%u%c${char_badge} ${vc_branch_name}"
    zstyle ":vcs_info:git:*" formats " %c%u%m${char_badge} ${vc_branch_name}"
  ;;

# svn sepecific 
zstyle ':vcs_info:svn:*' branchformat "%b"
esac

# Show untracked file status on git status line
+vi-use_git_untracked() {
  if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == "true" ]] &&
    git status --porcelain | grep -m 1 "^??" &>/dev/null; then
    hook_com[misc]=$vc_git_untracked_status
  else
    hook_com[misc]=""
  fi
}

# UTILS ========================================================================

setopt PROMPT_SUBST

# Prepare git status line
prepareGitStatusLine() {
  echo '${vcs_info_msg_0_}'
} 

# Prepare prompt line limiter
printPsOneLimiter() {
  local termwidth
  local spacing=""
  
  ((termwidth = ${COLUMNS} - 1))
  
  for i in {1..$termwidth}; do
    spacing="${spacing}${char_vertical_divider}"
  done
  
  echo $ANSI_dim_black$char_down_and_right_divider$spacing$ANSI_reset
}

# PROMPT LINES  ================================================================

PROMPT="%F{236}${char_up_and_right_divider} %f%F{80}%~%f$(prepareGitStatusLine)
%F{85} ${char_arrow}%f "

RPROMPT=""

# 𝗌𝗌𝗁:
# HOOKS ======================================================================== 

precmd() {
  if [[ $VCS != "" ]]; then
    vcs_info
  fi
  printPsOneLimiter
}

# LS_COLORS ====================================================================
LSCOLORS=gxafexDxfxegedabagacad
export LSCOLORS

LS_COLORS=$LS_COLORS:"di=36":"ln=30;45":"so=34:pi=1;33":"ex=35":"bd=34;46":"cd=34;43":"su=30;41":"sg=30;46":"ow=30;43":"tw=30;42":"*.js=01;33":"*.json=33":"*.jsx=38;5;117":"*.ts=38;5;75":"*.css=38;5;27":"*.scss=38;5;169"
export LS_COLORS

# COMPLETER SETTINGS ===========================================================

# list of completers to use
zstyle ":completion:*::::" completer _expand _complete _ignored _approximate
zstyle -e ":completion:*:approximate:*" max-errors "reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )"
zstyle ":completion:*:expand:*" tag-order all-expansions

# formatting and messages
local completion_descriptions="%B%F{85} › %f%%F{green}%d%b%f"
local completion_warnings="%F{yellow} › %fno matches for %F{green}%d%f"
local completion_error="%B%F{red} › %f%e %d error"

zstyle ":completion:*" menu select
zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS} "ma=38;5;253;48;5;23"
zstyle ":completion:*" verbose yes
zstyle ":completion:*:descriptions" format $completion_descriptions
zstyle ":completion:*:warnings" format $completion_warnings
zstyle ":completion:*:messages" format "%d"
zstyle ":completion:*:corrections" format $completion_error
zstyle ":completion:*" group-name ''

# match uppercase from lowercase
zstyle ":completion:*" matcher-list "m:{a-z}={A-Z}"

# offer indexes before parameters in subscripts
zstyle ":completion:*:*:-subscript-:*" tag-order indexes parameters

# Filename suffixes to ignore during completion (except after rm command)
zstyle ":completion:*:*:(^rm):*:*files" ignored-patterns "*?.o" "*?.c~" "*?.old" "*?.pro"

# ignore completion functions (until the _ignored completer)
zstyle ":completion:*:functions" ignored-patterns "_*"
# ==============================================================================
