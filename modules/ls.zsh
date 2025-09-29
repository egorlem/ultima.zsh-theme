# Ultima LS Configuration Module
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

initLsSettings() {
  LSCOLORS=gxafexdxfxagadabagacad
  export LSCOLORS                                                           #BSD

  LS_COLORS="di=36:ln=30;45:so=34:pi=33:ex=35:bd=30;46:cd=30;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
  export LS_COLORS                                                          #GNU

  # Автовыбор правильной системы с алиасами
  if [[ "$OSTYPE" == darwin* ]]; then
    alias ls='ls -G'
    alias ll='ls -laG'
    alias la='ls -laG'
    echo "Ultima: ls module initialized (BSD/macOS mode)"
  else
    alias ls='ls --color=auto'
    alias ll='ls -la --color=auto'
    alias la='ls -la --color=auto'
    echo "Ultima: ls module initialized (GNU/Linux mode)"
  fi
  
  # Общие алиасы
  alias l='ls -CF'
}

# Автоинициализация
if [[ -z "$ULTIMA_CORE_LOADED" ]]; then
  initLsSettings
fi
