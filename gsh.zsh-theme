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
