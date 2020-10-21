autoload -Uz vcs_info

RST="\e[0m"         # RESET COLOR
DVC="\e[2;38;05;255m" # DIVIDER COLOR DIM
DVCD="\e[38;05;236m"

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*:*' check-for-changes true # can be slow on big repos
zstyle ':vcs_info:*:*' unstagedstr ''
zstyle ':vcs_info:*:*' actionformats "${DVC} on: ${RST}%F{85}%u%b%f %a"
zstyle ':vcs_info:*:*' formats "%K{235}${DVC} on:${RST}%F{235}⮀%f%F{85}%u %b%f${DVCD} ┛${RST}"

pwdlength=0
branchlength=0
branchdivider=""
pwdlength=""
pwddivider=""
getBranchLength() {
  local git="${vcs_info_msg_0_}"
  if [ ${#git} != 0 ]; then
    ((git = ${#git} - 63))
  else
    git=0
    branchlength=0
  fi
  branchlength=$git
}
getPwd() {
  echo "${PWD/$HOME/~}"
}
getPwdLength() {
  local pwdvd=""
  for i in {1.."${#$(getPwd)}"}; do
    pwdvd="${pwdvd}━"
  done
  pwdlength="━${pwdvd}━┳"
}
getPwdDivider() {
  if [ ${branchlength} != 0 ]; then
    pwddivider="${DVCD}┻${RST}"
  else
    pwddivider="${DVCD}┛${RST}"
  fi
}
getBarnchDivider() {
  local BRANCHTOPDIVIDER=""
  if [ ${branchlength} != 0 ]; then
    for i in {1..$branchlength}; do
      BRANCHTOPDIVIDER="${BRANCHTOPDIVIDER}━"
    done
    branchdivider="${BRANCHTOPDIVIDER}┳"
    else
    branchdivider="━"
  fi 
}
lpLineOne() {
  echo "%F{236}┣%K{235} %f%F{151}%~%f %k${pwddivider}${vcs_info_msg_0_}"
}
lpLineTwo() {
  echo "%F{236}┗ %f%n%F{237} ⮁%f "
}
rpLine() {
  if [[ -n "$SSH_CLIENT" || -n "$SSH2_CLIENT" ]]; then
    RPROMPT='%F{⫘} %fSSH'
  fi
}
PROMPT='$(lpLineOne)
$(lpLineTwo)'
RPROMPT='$(rpLine)'
# COLUMN DIVIDER \u2500 ─
# ROW DIVEDER \u2502 │
precmd() {
  vcs_info
  getPwdLength
  getBranchLength
  getPwdDivider
  getBarnchDivider
  local termwidth
  ((termwidth = ${COLUMNS} - ${branchlength} - ${#$(getPwd)} - 5))
  local DIVIDERCOLOR="\e[38;05;236m" # \e[2;38;05;232m
  local spacing=""
  for i in {1..$termwidth}; do
    spacing="${spacing}━"
  done
  local BRANCHTOPDIVIDER=""
  if [ ${branchlength} != 0 ]; then
    for i in {1..$branchlength}; do
      BRANCHTOPDIVIDER="${BRANCHTOPDIVIDER}M"
    done
  fi
  echo $DIVIDERCOLOR"┏"$pwdlength$branchdivider$spacing$RST
}
# BSD/Darwin/OSX DIR COLOR
LSCOLORS=Cxfxcxdxbxegedabagacad
export LSCOLORS
# GNU/Linux/DIR COLOR
LS_COLORS=$LS_COLORS:"di=1;32":"*.js=01;33":"*.json=33":"*.jsx=38;5;117":"ma=48;5;24":"*.ts=38;5;75":"*.css=38;5;27":"*.scss=38;5;169"
export LS_COLORS
