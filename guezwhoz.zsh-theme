# guezwhoz zsh theme v1.0.0 - https://github.com/guesswhozzz/guezwhoz-zshell

autoload -Uz vcs_info
RST="\e[0m"           # RESET COLOR
DVC="\e[2;38;05;255m" # DIVIDER COLOR DIM

###GRAPHICS VARIABLES

ARROW="\u203a" #DIVIDER ARROW ›
DIVD1="\u2514" #DIVIDER UP AND RIGHT " └ "
DIVD2="\u250c" #DIVIDER DOWN AND RIGHT " ┌ "
DIVD3="\u2500" #DIVIDER HORIZONTAL " ─ "
DT="\u22c5"    #DOT ⋅

# Git ==========================================================================

HASH="%F{151}%6.6i%f %F{236}${ARROW}%f "
ACTION="%F{238}%a %f%F{236}${ARROW}%f"
BADGE="%F{238} 𝗈𝗇%f%F{236}${ARROW}%f"
BRANCH="%F{85}%b%f"
UNTRACKED="%F{74}${DT}𝗎𝗍${ARROW}%f"
UNSTAGED="%F{80}${DT}𝗎𝗌${ARROW}%f"
STAGED="%F{115}${DT}𝗌${ARROW}%f"

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*:*' get-revision true
zstyle ':vcs_info:git*:*' check-for-changes true

# hash changes branch misc
zstyle ':vcs_info:git*:*' unstagedstr $UNSTAGED
zstyle ':vcs_info:*' stagedstr $STAGED
zstyle ':vcs_info:git*' formats "%m%u%c${BADGE} ${BRANCH}"
zstyle ':vcs_info:git*' actionformats "${ACTION} ${HASH}%m%u%c${BADGE} ${BRANCH}"
zstyle ':vcs_info:git*+set-message:*' hooks untracked

# Show unracked on prompt
+vi-untracked() {
  if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == 'true' ]] &&
    git status --porcelain | grep -m 1 '^??' &>/dev/null; then
    hook_com[misc]=$UNTRACKED
  else
    hook_com[misc]=''
  fi
}
# Prompt =======================================================================

DIVIDERCOLOR="\e[38;05;236m"

lpLineOne() {
  echo "%F{236}${DIVD1} %f%F{80}%~%f ${vcs_info_msg_0_}"
}
lpLineTwo() {
  echo "%F{85} ${ARROW}%f "
}
rpLine() {
  if [[ -n "$SSH_CLIENT" || -n "$SSH2_CLIENT" ]]; then
    RPROMPT='SSH'
  fi
}
# Pring prompt line limiter
printPsOneLiminer() {
  local termwidth
  ((termwidth = ${COLUMNS} - 1))
  local spacing=""
  for i in {1..$termwidth}; do
    spacing="${spacing}${DIVD3}"
  done
  echo $DIVIDERCOLOR$DIVD2$spacing$RST
}
# Prompt lines
PROMPT='$(lpLineOne)
$(lpLineTwo)'
RPROMPT='$(rpLine)'

# ==============================================================================

precmd() {
  vcs_info
  printPsOneLiminer
}

# LS_COLORS======================================================================

LSCOLORS=gxafexDxfxegedabagacad
export LSCOLORS
LS_COLORS=$LS_COLORS:"di=36":"ln=30;45":"so=34:pi=1;33":"ex=35":"bd=34;46":"cd=34;43":"su=30;41":"sg=30;46":"ow=30;43":"tw=30;42":"*.js=01;33":"*.json=33":"*.jsx=38;5;117":"ma=38;5;253;48;5;24":"*.ts=38;5;75":"*.css=38;5;27":"*.scss=38;5;169"
export LS_COLORS
