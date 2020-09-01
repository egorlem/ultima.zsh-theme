case "$TERM" in
'xterm') TERM=xterm-256color ;;
'screen') TERM=screen-256color ;;
'Eterm') TERM=Eterm-256color ;;
esac

#GREP COLOR
export GREP_OPTIONS='--color=always'
#GIT
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}[\uE0A0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[cyan]%}] "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[red]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN="] "
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"
PROMPT='$fg_bold[cyan]%~%{$reset_color%}
[%m@$USER] $(git_prompt_info)'
RPROMPT=''
#BSD/Darwin/OSX DIR COLOR
LSCOLORS=Cx
export LSCOLORS
#GNU/Linux/DIR COLOR
LS_COLORS=$LS_COLORS:"di=1;32":"*.js=01;33":"*.json=33"
export LS_COLORS

#LESS CONFIG
export LESS='--quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4'

export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[38;5;159m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
