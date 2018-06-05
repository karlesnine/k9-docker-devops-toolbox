# VIM stuff
export VIM="/usr/share/vim"

# colored echo
eCYAN="\033[0;36m"
eGRAY="\033[0;37m"
eRED="\033[0;31m"
eYELLOW="\033[0;33m"
eGREEN="\033[0;32m"
eBLUE="\033[0;34m"
eLIGHT_RED="\033[1;31m"
eLIGHT_GREEN="\033[1;32m"
eWHITE="\033[1;37m"
eLIGHT_GRAY="\033[0;37m"
eCOLOR_NONE="\033[0;39m"

# colored prompt
CYAN="\[\033[0;36m\]"
GRAY="\[\033[0;37m\]"
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
BLUE="\[\033[0;34m\]"
LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
WHITE="\[\033[1;37m\]"
LIGHT_GRAY="\[\033[0;37m\]"
COLOR_NONE="\[\e[0m\]"

# PROMPT
GIT_BIN_PATH=/usr/bin/git
if [ -f $GIT_BIN_PATH ]; then
  source /etc/bash_completion.d/git-prompt
  export GIT_PROMPT_ONLY_IN_REPO=1
  export GIT_PS1_SHOWDIRTYSTATE=true # */+ for dirty
  export GIT_PS1_SHOWSTASHSTATE=true # $ for stashes
  export GIT_PS1_SHOWUNTRACKEDFILES=true # % for untracked
  /usr/bin/git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
  /usr/bin/git config --global color.branch auto
  /usr/bin/git config --global color.diff auto
  /usr/bin/git config --global color.interactive auto
  /usr/bin/git config --global color.status auto
  /usr/bin/git config --global color.ui true

  # export PS1="${debian_chroot:+($debian_chroot)}${CYAN}[\u@\H:${GRAY}${GREEN} \$(__git_ps1 '(%s)') ${RED}\w/ ${CYAN} ]${GRAY} "
  export PS1="${debian_chroot:+($debian_chroot)}${CYAN}[ME@\h:${GRAY}${GREEN} \$(__git_ps1 '(%s)') ${RED}\w/ ${CYAN} ]${GRAY} "
else
  export PS1="${CYAN}[ME@\h:${GRAY}\t ${RED}\w${CYAN}]${GRAY} "
fi

# SOME ALIASES
# alias ls='ls -G' #Color
# alias ll='ls -alF'
# alias la='ls -A'
# alias l='ls -CF'
# alias df="df -h"
alias rh="history | grep"
alias l='ls $LS_OPTIONS -lA'
alias ll='ls -lh'
alias ls="ls --color=always"

# === nice a ionice ===
# Dangerous commands used by developers
alias df="ionice -c2 -n7 nice -n19 df"
alias du="ionice -c2 -n7 nice -n19 du"
alias ncdu="ionice -c2 -n7 nice -n19 ncdu"
alias mv="ionice -c2 -n7 nice -n19 mv"
alias cp="ionice -c2 -n7 nice -n19 cp"
alias htop="nice -n19 ionice -c2 -n7 /usr/bin/htop"
alias top="nice -n19 ionice -c2 -n7 /usr/bin/top"

# === HISTORY STUFF ===
# Date Time in Bash History
HISTTIMEFORMAT="%d/%m/%y %T "
export HISTTIMEFORMAT="%d/%m/%y %T "
# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups:ignorespace
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth
# ignore duplicate (&) and unuseful entries in history
export HISTIGNORE="&:ls:exit:l:rc:ls -l:cd ..:ll:history*"
# keep more than the default 500 lines of history (for the whole history file)
export HISTFILESIZE=20000
# same, per session
export HISTSIZE=$HISTFILESIZE
# append each session history to history file instead of overwriting it each time
shopt -s histappend
# reedit command when substitution fails
shopt -s histreedit
# verify each command from history first, before running it
shopt -s histverify
# store history at each prompt in order to merge history from all sessions
export PROMPT_COMMAND="history -a"
