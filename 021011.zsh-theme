# 021011 zsh theme v1.2.0 - https://github.com/guesswhozzz/021011.zsh-theme

autoload -Uz compinit 
autoload -Uz vcs_info
compinit

local RST="\e[0m"

# GRAPHICS VARIABLES ===========================================================
local ARROW="›" #DIVIDER ARROW \u203a
local DIVD1="└" #DIVIDER UP AND RIGHT " └ " \u2514
local DIVD2="┌" #DIVIDER DOWN AND RIGHT " ┌ " \u250c

local DIVD3="─" #Vertical divider " ─ " \u2500
local DT="⋅" #Dot ⋅ \u22c5

# Git ==========================================================================
local HASH="%F{151}%6.6i%f %F{236}${ARROW}%f "
local ACTION="%F{238}%a %f%F{236}${ARROW}%f"
local BADGE="%F{238} 𝗈𝗇 %f%F{236}${ARROW}%f"
local BRANCH="%F{85}%b%f"
local UNTRACKED="%F{74} U ${ARROW}%f"
local UNSTAGED="%F{80} M ${ARROW}%f"
local STAGED="%F{115} A ${ARROW}%f"

zstyle ":vcs_info:*" enable git
zstyle ":vcs_info:git*:*" get-revision true
zstyle ":vcs_info:git*:*" check-for-changes true

# hash changes branch misc
zstyle ":vcs_info:git*:*" unstagedstr $UNSTAGED
zstyle ":vcs_info:*" stagedstr $STAGED
zstyle ":vcs_info:git*" formats "%c%u%m${BADGE} ${BRANCH}"
zstyle ":vcs_info:git*" actionformats "${ACTION} ${HASH}%m%u%c${BADGE} ${BRANCH}"
zstyle ":vcs_info:git*+set-message:*" hooks untracked

# Show unracked on prompt
+vi-untracked() {
  if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == "true" ]] &&
    git status --porcelain | grep -m 1 "^??" &>/dev/null; then
    hook_com[misc]=$UNTRACKED
  else
    hook_com[misc]=""
  fi
}

# Prompt =======================================================================
local DIVIDERCOLOR="\e[38;05;236m"

# lpLineOne() {
#   echo "%F{236}${DIVD1} %f%F{80}%~%f ${vcs_info_msg_0_}"
# }

# lpLineTwo() {
#   echo "%F{85} ${ARROW}%f "
# }

# rpLine() {
# }

prepareGitStatusLine() {
  echo '${vcs_info_msg_0_}'
} 

# Pring prompt line limiter
printPsOneLimiter() {
  local termwidth
  ((termwidth = ${COLUMNS} - 1))
  local spacing=""
  for i in {1..$termwidth}; do
    spacing="${spacing}${DIVD3}"
  done
  echo $DIVIDERCOLOR$DIVD2$spacing$RST
}

# Prompt lines
PROMPT="%F{236}${DIVD1} %f%F{80}%~%f $(prepareGitStatusLine)
%F{85} ${ARROW}%f "

# RPROMPT="$(rpLine)"

# Preloader ====================================================================
precmd() {
  vcs_info
  printPsOneLimiter
}

# LS_COLORS ====================================================================
LSCOLORS=gxafexDxfxegedabagacad
export LSCOLORS

LS_COLORS=$LS_COLORS:"di=36":"ln=30;45":"so=34:pi=1;33":"ex=35":"bd=34;46":"cd=34;43":"su=30;41":"sg=30;46":"ow=30;43":"tw=30;42":"*.js=01;33":"*.json=33":"*.jsx=38;5;117":"*.ts=38;5;75":"*.css=38;5;27":"*.scss=38;5;169"
export LS_COLORS

# Completer ====================================================================

# list of completers to use
zstyle ":completion:*::::" completer _expand _complete _ignored _approximate
zstyle -e ":completion:*:approximate:*" max-errors "reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )"
zstyle ":completion:*:expand:*" tag-order all-expansions

# formatting and messages
local DESCRIPTIONS="%B%F{85} › %f%%F{green}%d%b%f"
local WARNINGS="%F{yellow} › %fno matches for %F{green}%d%f"
local ERROR="%B%F{red} › %f%e %d error"

zstyle ":completion:*" menu select
zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS} "ma=38;5;253;48;5;23"
zstyle ":completion:*" verbose yes
zstyle ":completion:*:descriptions" format $DESCRIPTIONS
zstyle ":completion:*:messages" format "%d"
zstyle ":completion:*:warnings" format $WARNINGS
zstyle ":completion:*:corrections" format $ERROR
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