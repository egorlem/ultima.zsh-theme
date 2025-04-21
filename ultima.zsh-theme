# Ultima Zsh Theme p2.c7 - https://github.com/egorlem/ultima.zsh-theme
#
# Minimalistic .zshrc config contains all of the settings required for 
# comfortable terminal use.
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

autoload -Uz compinit; compinit

# LOCAL/VARIABLES/ANSI ---------------------------------------------------------

ANSI_reset="\x1b[0m"
ANSI_dim_black="\x1b[0;30m"

# LOCAL/VARIABLES/GRAPHIC ------------------------------------------------------

char_arrow="›"                                                  #Unicode: \u203a
char_up_and_right_divider="└"                                   #Unicode: \u2514
char_down_and_right_divider="┌"                                 #Unicode: \u250c
char_vertical_divider="─"                                       #Unicode: \u2500

# SEGMENT/VCS_STATUS_LINE ------------------------------------------------------

export VCS="git"

current_vcs="\":vcs_info:*\" enable $VCS"
char_badge="%F{black} on %f%F{black}${char_arrow}%f"
vc_branch_name="%F{green}%b%f"

vc_action="%F{black}%a %f%F{black}${char_arrow}%f"
vc_unstaged_status="%F{cyan} M ${char_arrow}%f"

vc_git_staged_status="%F{green} A ${char_arrow}%f"
vc_git_hash="%F{green}%6.6i%f %F{black}${char_arrow}%f"
vc_git_untracked_status="%F{blue} U ${char_arrow}%f"

if [[ $VCS != "" ]]; then
  autoload -Uz vcs_info
  eval zstyle $current_vcs
  zstyle ':vcs_info:*' get-revision true
  zstyle ':vcs_info:*' check-for-changes true
fi

case "$VCS" in 
   "git")
    # git sepecific 
    zstyle ':vcs_info:git*+set-message:*' hooks use_git_untracked
    zstyle ':vcs_info:git:*' stagedstr $vc_git_staged_status
    zstyle ':vcs_info:git:*' unstagedstr $vc_unstaged_status
    zstyle ':vcs_info:git:*' actionformats "  ${vc_action} ${vc_git_hash}%m%u%c${char_badge} ${vc_branch_name}"
    zstyle ':vcs_info:git:*' formats " %c%u%m${char_badge} ${vc_branch_name}"
  ;;

  # svn sepecific 
  "svn")
    zstyle ':vcs_info:svn:*' branchformat "%b"
    zstyle ':vcs_info:svn:*' formats " ${char_badge} ${vc_branch_name}"
  ;;

  # hg sepecific 
  "hg")
    zstyle ':vcs_info:hg:*' branchformat "%b"
    zstyle ':vcs_info:hg:*' formats " ${char_badge} ${vc_branch_name}"
  ;;
esac

# Show untracked file status char on git status line
+vi-use_git_untracked() {
  if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == "true" ]] &&
    git status --porcelain | grep -m 1 "^??" &>/dev/null; then
    hook_com[misc]=$vc_git_untracked_status
  else
    hook_com[misc]=""
  fi
}

# SEGMENT/SSH_STATUS -----------------------------------------------------------

ssh_marker=""

if [[ -n "$SSH_CLIENT" || -n "$SSH2_CLIENT" ]]; then
 ssh_marker="%F{green}SSH%f%F{black}:%f"
fi

# UTILS ------------------------------------------------------------------------

setopt PROMPT_SUBST

# Prepare git status line
prepareGitStatusLine() {
  echo '${vcs_info_msg_0_}'
} 

# Prepare prompt line limiter
printPsOneLimiter() {
  local termwidth
  local spacing=""
  
  ((termwidth = ${COLUMNS} - 1))
  
  for i in {1..$termwidth}; do
    spacing="${spacing}${char_vertical_divider}"
  done
  
  echo $ANSI_dim_black$char_down_and_right_divider$spacing$ANSI_reset
}

# ENV/VARIABLES/PROMPT_LINES ---------------------------------------------------

# PS1 arrow - green # PS2 arrow - cyan # PS3 arrow - white

PROMPT="%F{black}${char_up_and_right_divider} ${ssh_marker} %f%F{cyan}%~%f$(prepareGitStatusLine)
%F{green} ${char_arrow}%f "

RPROMPT=""

# PS2 Example 
# wc << EOF 
# wc << HEAR 
PS2="%F{black} %_ %f%F{cyan}${char_arrow} "

# PS3 The value of this parameter is used as the prompt for the select
# command (see SHELL GRAMMAR above).
# PS3 Example 
# select x in foo bar baz; do echo $x; done
PS3=" ${char_arrow} "

# ENV/HOOKS --------------------------------------------------------------------

precmd() {
  if [[ $VCS != "" ]]; then
    vcs_info
  fi
  printPsOneLimiter
}

# ENV/VARIABLES/LS_COLORS ------------------------------------------------------

LSCOLORS=gxafexdxfxagadabagacad
export LSCOLORS                                                             #BSD

LS_COLORS="di=36:ln=30;45:so=34:pi=33:ex=35:bd=30;46:cd=30;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
export LS_COLORS                                                            #GNU

# ENV/VARIABLES/LESS AND MAN ---------------------------------------------------

export LESS='--quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4'
export LESS_TERMCAP_mb=$'\x1b[0;36m'                                # begin bold
export LESS_TERMCAP_md=$'\x1b[0;34m'                               # begin blink
export LESS_TERMCAP_me=$'\x1b[0m'                             # reset bold/blink
export LESS_TERMCAP_so=$' \x1b[0;42;30m '                  # begin reverse video
export LESS_TERMCAP_se=$' \x1b[0m'
export LESS_TERMCAP_us=$'\x1b[0m\x1b[0;32m'                    # begin underline
export LESS_TERMCAP_ue=$'\x1b[0m'                              # reset underline
export GROFF_NO_SGR=1     

# SEGMENT/COMPLETION -----------------------------------------------------------

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

# ------------------------------------------------------------------------------
