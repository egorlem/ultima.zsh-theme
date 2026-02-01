# Ultima XDG path context
zstyle ':ultima:xdg' enable yes

zstyle ':ultima:xdg' keys \
  XDG_CONFIG_HOME \
  XDG_CACHE_HOME \
  XDG_DATA_HOME \
  XDG_STATE_HOME \
  ZDOTDIR

# Optional overrides
# zstyle ':ultima:xdg' XDG_CONFIG_HOME ~/.config

zstyle ':ultima:xdg' format ' as $%s'
zstyle ':ultima:xdg' color 4