LS_COLORS=$LS_COLORS:"di=1;32":"*.js=01;33":"*.json=33"
export LS_COLORS

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} "ma=48;5;24"