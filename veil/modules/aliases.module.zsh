# Vail Completion Module
#
# Enhanced Zsh completion system with caching and customizable styles
# ------------------------------------------------------------------------------
# License: WTFPL - https://github.com/egorlem/ultima.zsh-theme/blob/main/LICENSE 
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Egor Lem <guezwhoz@gmail.com> / egorlem.com
#
# ------------------------------------------------------------------------------

initAliasesSettings() {
  # Безопасность
  alias rm='rm -i'
  alias cp='cp -i'
  alias mv='mv -i'
  
  # Улучшенный ls
  alias l='ls -1'
  alias ll='ls -lh'
  alias la='ls -lAh'
  alias lsd='ls -l | grep "^d"'  # только директории
  
  # Git shortcuts
  alias gs='git status'
  alias ga='git add'
  alias gc='git commit'
  alias gd='git diff'
  alias gl='git log --oneline --graph'
  
  # System monitoring
  alias cpu='top -o cpu'
  alias mem='top -o rsize'
  alias ports='netstat -tulanp'
  
  # Network
  alias ip='curl -s ifconfig.me'
  alias localip='ipconfig getifaddr en0'
  alias ping='ping -c 5'
  
  # Development
  alias py='python3'
  alias pip='pip3'
  
  echo "Ultima: aliases module initialized"
}