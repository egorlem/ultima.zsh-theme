setopt prompt_subst
xrdb -merge ~/.Xresources
case "$TERM" in
'xterm') TERM=xterm-256color ;;
'screen') TERM=screen-256color ;;
'Eterm') TERM=Eterm-256color ;;
esac
alias ls='ls --color=auto'
alias wpm='python3 -m wpm'
LS_COLORS=$LS_COLORS:"di=1;32":"*.js=01;33":"*.json=33"
export LS_COLORS

export LESS='--quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4'

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
#zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*:*' check-for-changes true # can be slow on big repos
zstyle ':vcs_info:*:*' unstagedstr '%F{red}'
zstyle ':vcs_info:*:*' actionformats "[%F{81}%u%b%f %a]"
zstyle ':vcs_info:*:*' formats       "[%F{81}%u%b%f]"

PROMPT='%F{238}⌈%f%F{50}%~%f
%F{238}⌊%f[%m@%n] ${vcs_info_msg_0_}%F{238} 〉%f' 

if [[ -n "$SSH_CLIENT" || -n "$SSH2_CLIENT" ]]; then 
  RPROMPT='%F{238}SSH%f'
 fi