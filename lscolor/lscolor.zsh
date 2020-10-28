LS_COLORS=$LS_COLORS:"di=1;32":"*.js=01;33":"*.json=33":"*.jsx=38;5;117":"ma=48;5;24":"*.ts=38;5;75":"*.css=38;5;27":"*.scss=38;5;169"
export LS_COLORS


autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} 