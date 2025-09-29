# Ultima LESS Configuration Module
# Источник: ${${(%):-%x}:A}

# Ultima Completion Module
#
# This code doesn't provide much value, but it will make using zsh a little more
# enjoyable.
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Egor Lem <guezwhoz@gmail.com> / egorlem.com
#
# ------------------------------------------------------------------------------

char_arrow="›"

initCompletionSettings() {
  setopt MENU_COMPLETE

  completion_descriptions="%F{blue} ${char_arrow} %f%%F{green}%d%f"
  completion_warnings="%F{yellow} ${char_arrow} %fno matches for %F{green}%d%f"
  completion_error="%B%F{red} ${char_arrow} %f%e %d error"

  zstyle ':completion:*' completer _expand _complete _ignored _approximate
  zstyle ':completion:*' use-cache on
  zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
  zstyle ':completion:*' verbose yes
  zstyle ':completion:*' menu select
  zstyle ':completion:*' matcher-list "m:{a-z}={A-Z}"
  zstyle ':completion:*' group-name ''

  zstyle ':completion:*:*:*:*:descriptions' format $completion_descriptions
  zstyle ':completion:*:*:*:*:corrections' format $completion_error
  zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS} "ma=0;42;30"
  zstyle ':completion:*:*:*:*:warnings' format $completion_warnings
  zstyle ':completion:*:*:*:*:messages' format "%d"

  zstyle ':completion:*:expand:*' tag-order all-expansions
  zstyle ':completion:*:approximate:*' max-errors "reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )"
  zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
  zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns "*?.o" "*?.c~" "*?.old" "*?.pro"
  zstyle ':completion:*:functions' ignored-patterns "_*"

  zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

  zstyle ':completion:*:parameters' list-colors '=*=34'
  zstyle ':completion:*:options' list-colors '=^(-- *)=34'
  zstyle ':completion:*:commands' list-colors '=*=1;34'


  echo "Ultima: Completion module initialized"
}

if [[ -z "$ULTIMA_CORE_LOADED" ]]; then
  initCompletionSettings
fi