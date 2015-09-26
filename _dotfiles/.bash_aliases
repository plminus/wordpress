# .bash_aliases

# aliases {{{

#alias ls='ls -F --color=auto --ignore-backups --human-readable'
#alias ls='ls --color -F'
alias ls='ls -F --color=auto'
alias ll='ls -l'
alias la='ls -la'
alias tree='tree -C'
alias tmux="TERM=screen-256color-bce tmux -f $HOME/.tmux.conf"

alias c='clear'
alias f='free -lmt'
alias m='vmstat -ap -S M'
alias n='echo -e "\e[38;5;83m"; date +"%Y-%m-%d (%a) %T %Z"; echo -e "\e[0m"'
alias p='ps arcwwwxo "pid uid gid user command %cpu %mem" | grep -v grep | head -13'

alias myps='ps -t `tty`'
alias now='date +%Y%m%d_%H%M%S'

alias opentcp='netstat -an | grep ^tcp'
alias openudp='netstat -an | grep ^udp'

alias dir1="find . -maxdepth 1 -type d | grep -v ^.$ | xargs -n 1 du -hs"
alias dir2="find . -maxdepth 2 -type d | grep -v ^.$ | xargs -n 1 du -hs"

alias gta="ls | xargs -n 1 -I% bash -c 'cd % && git pull'"
alias gti="git"

# }}}

