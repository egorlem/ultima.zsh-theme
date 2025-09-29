# modules/environment.zsh
initEnvironmentSettings() {
  export EDITOR='nano'  # или vim, если предпочитаете
  export VISUAL='nano'
  export PAGER='less'
  
  # Locale
  export LANG='en_US.UTF-8'
  export LC_ALL='en_US.UTF-8'
  
  # Development
  export NODE_ENV='development'
  export PYTHONSTARTUP="$HOME/.pythonrc"
  
  # Path
  export PATH="$HOME/.local/bin:$PATH"
  
  echo "Ultima: environment module initialized"
}