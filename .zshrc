setopt prompt_subst
xrdb -merge ~/.Xresources
case "$TERM" in
'xterm') TERM=xterm-256color ;;
'screen') TERM=screen-256color ;;
'Eterm') TERM=Eterm-256color ;;
esac
alias ls='ls --color=auto'
alias wpm='python3 -m wpm'
LS_COLORS=$LS_COLORS:"di=1;32":"*.js=01;33":"*.json=33":"*.jsx=48;5;24"
export LS_COLORS

export LESS="--quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4"

export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[38;5;159m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

#source /home/egorl/projects/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

 
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*:*' check-for-changes true # can be slow on big repos
zstyle ':vcs_info:*:*' unstagedstr '%F{red}'
zstyle ':vcs_info:*:*' actionformats "[%F{81}%u%b%f %a]"
zstyle ':vcs_info:*:*' formats       "[%F{81}%u%b%f]"

PROMPT='%F{238}⌈%f%F{50}%~%f
%F{238}⌊%f[%m@%n] ${vcs_info_msg_0_}%F{238} 〉%f' 

if [[ -n "$SSH_CLIENT" || -n "$SSH2_CLIENT" ]]; then 
  RPROMPT='%F{238}SSH%f'
 fi


RST="\e[0m"
ZSH_THEME_GIT_PROMPT_PREFIX="%F{237} on: %f%F{85}" # %{$fg[85]%}\u2b60
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[red]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"
# 2570 ╰  257C ╼ 2578 ╸ 257E ╾ 298A ⦊

lpLineOne() {
  echo "%F{236}├ %f%F{151}%~%f$(git_prompt_info)"
}
lpLineTwo() {
  echo "%F{236}└ %f%n%F{237} ⮁%f "
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
  local termwidth
  ((termwidth = ${COLUMNS} - 1))
  local DIVIDERCOLOR="\e[38;05;236m"
  local spacing=""
  for i in {1..$termwidth}; do
    spacing="${spacing}\u2500"
  done
  echo $DIVIDERCOLOR"┌"$spacing$RST
}
#BSD/Darwin/OSX DIR COLOR
LSCOLORS=Cxfxcxdxbxegedabagacad
export LSCOLORS
#GNU/Linux/DIR COLOR
LS_COLORS=$LS_COLORS:"di=1;32":"*.js=01;33":"*.json=33":"*.jsx=38;5;117":"ma=48;5;24":"*.ts=38;5;75":"*.css=38;5;27":"*.scss=38;5;169"
export LS_COLORS
