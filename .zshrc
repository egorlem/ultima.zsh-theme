autoload -Uz vcs_info

RST="\e[0m"         # RESET COLOR
DVC="\e[2;38;05;255m" # DIVIDER COLOR DIM
DVCD="\e[38;05;236m"

###GRAPHICS VARIABLES
DIVDARROW="\u2b80"    #DIVIDER ARROW " ⮀ " 
DIVDARROW2="⮁"
DIVD1="\u2518"        #DIVIDER UP AND LEFT " ┘ "
DIVD2="\u2514"        #DIVIDER UP AND RIGHT " └ "  
DIVD3="\u2510"        #DIVIDER DOWN AND LEFT " ┐ "  
DIVD4="\u250c"        #DIVIDER DOWN AND RIGHT " ┌ "  
DIVD5="\u2500"        #DIVIDER HORIZONTAL " ─ "
DIVD6="\u2534"        #DIVIDER UP AND HORIZONTAL " ┴ "
DIVD7="\u252c"        #DIVIDER DOWN AND HORIZONTAL " ┬ " 
DIVD8="\u251c"        #DIVIDER VERTICAL AND RIGHT" ├ "

##GIT BRANCH STYLE
gitPrefix="%K{235}${DVC} on:${RST}%F{235}${DIVDARROW}%f"
gitBranch="%F{85}%u %b%f${DVCD}${DIVD1}${RST}"
gitStyleLine="${gitPrefix}${gitBranch}"

#${DVC} on: ${RST}%F{85}%u%b%f %a
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*:*' check-for-changes true # can be slow on big repos
zstyle ':vcs_info:*:*' unstagedstr ""
zstyle ':vcs_info:*:*' actionformats ""
zstyle ':vcs_info:*:*' formats $gitStyleLine

pwdlength=0
branchlength=0
branchdivider=""
pwdlength=""
pwddivider=""
getBranchLength() {
  local git="${vcs_info_msg_0_}"
  if [ ${#git} != 0 ]; then
    ((git = ${#git} - 73))
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
  local _pwdTopDivider=""
  for i in {1.."${#$(getPwd)}"}; do
   _pwdTopDivider="${_pwdTopDivider}${DIVD5}"
  done
  pwdlength="${DIVD5}${_pwdTopDivider}${DIVD5}${DIVD7}"
}

getPwdDivider() {
  if [ ${branchlength} != 0 ]; then
    pwddivider="${DVCD}${DIVD6}${RST}"
  else
    pwddivider="${DVCD}${DIVD1}${RST}"
  fi
}
getBarnchDivider() {
  local _BRANCH_TOP_DIVIDER=""
  if [ ${branchlength} != 0 ]; then
    for i in {1..$branchlength}; do
      _BRANCH_TOP_DIVIDER="${_BRANCH_TOP_DIVIDER}${DIVD5}"
    done
    branchdivider="${_BRANCH_TOP_DIVIDER}${DIVD7}"
    else
    branchdivider="${DIVD5}"
  fi 
}

lpLineOne() {
  echo "%F{236}├%K{235} %f%F{151}%~%f %k${pwddivider}${vcs_info_msg_0_}"
}
lpLineTwo() {
  echo "%F{236}└ %f%n%F{237} ⮁%f "
}

rpLine() {
  if [[ -n "$SSH_CLIENT" || -n "$SSH2_CLIENT" ]]; then
    RPROMPT='SSH'
  fi
} 

renderPrompt() {
  getPwdLength
  getBranchLength
  getPwdDivider
  getBarnchDivider
   local termwidth
  ((termwidth = ${COLUMNS} - ${branchlength} - ${#$(getPwd)} - 5))
  local DIVIDERCOLOR="\e[38;05;236m" # \e[2;38;05;232m
  local spacing=""
  for i in {1..$termwidth}; do
    spacing="${spacing}─"
  done
  local BRANCHTOPDIVIDER=""
  if [ ${branchlength} != 0 ]; then
    for i in {1..$branchlength}; do
      BRANCHTOPDIVIDER="${BRANCHTOPDIVIDER}M"
    done
  fi
  echo $DIVIDERCOLOR$DIVD4$pwdlength$branchdivider$spacing$RST
}

precmd() {
  vcs_info
  renderPrompt
}
# BSD/Darwin/OSX DIR COLOR
LSCOLORS=Cxfxcxdxbxegedabagacad
export LSCOLORS
# GNU/Linux/DIR COLOR
LS_COLORS=$LS_COLORS:"di=1;32":"*.js=01;33":"*.json=33":"*.jsx=38;5;117":"ma=48;5;24":"*.ts=38;5;75":"*.css=38;5;27":"*.scss=38;5;169"
export LS_COLORS

#PROMPT LINES
PROMPT='$(lpLineOne)
$(lpLineTwo)'
RPROMPT='$(rpLine)'

guezwhoz() {
  local c1='\e[48;05;235;38;05;85m' # TEST COLOR
 # local dividers="${DIVD1} ${DIVD2} ${DIVD3} ${DIVD4} ${DIVD5} ${DIVD6} ${DIVD7} ${DIVD8}"
  echo "\n ${c1} ${DIVDARROW} ${DIVDARROW2} ${RST}"
}