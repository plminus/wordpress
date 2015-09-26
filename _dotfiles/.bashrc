# .bashrc

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# source global definitions
test -f /etc/bashrc          && . /etc/bashrc
test -f /etc/bash_completion && . /etc/bash_completion

# sources
DOTFILES=`cat <<_EOT_
.bash_aliases
.cpanmrc
.haskellrc
.herokurc
.nodebrewrc
.nvmrc
.perlbrewrc
.pythonbrewrc
.rbenvrc
.rvmrc
.scalarc
_EOT_`

for i in $DOTFILES
do
  echo $i | grep -e "^$" -e "^#" >/dev/null 2>&1
  test $? -eq 0 && continue
  test -f ~/$i  && . ~/$i
done
unset DOTFILES

for i in $(find ~/ -maxdepth 1 -name .bash_include_\*)
do
  . $i
done

GIT_CONTRIB="/usr/share/doc/git*/contrib/completion"
test -f ${GIT_CONTRIB}/git-prompt.sh       && . ${GIT_CONTRIB}/git-prompt.sh
test -f ${GIT_CONTRIB}/git-completion.bash && . ${GIT_CONTRIB}/git-completion.bash
GIT_CONTRIB="/usr/share/git/completion"
test -f ${GIT_CONTRIB}/git-prompt.sh       && . ${GIT_CONTRIB}/git-prompt.sh
test -f ${GIT_CONTRIB}/git-completion.bash && . ${GIT_CONTRIB}/git-completion.bash
GIT_CONTRIB="/usr/local/etc/bash_completion.d"
test -f ${GIT_CONTRIB}/git-prompt.sh       && . ${GIT_CONTRIB}/git-prompt.sh
test -f ${GIT_CONTRIB}/git-completion.bash && . ${GIT_CONTRIB}/git-completion.bash

# A righteous umask
umask 002
#umask 022

# env {{{

PATH=/usr/local/sbin:/usr/local/bin:$HOME/bin:$PATH
PATH=$PATH:/opt/bin
export PATH

export LANG=ja_JP.UTF-8
export LC_DATE=C
export TZ=JST-9
export EDITOR=vim
export PAGER=less
#export PAGER=vimpager
export GREP_OPTIONS="--color=auto"
export LESS="-R -i -x4"

for i in autocd cdable_vars cdspell checkwinsize cmdhist dirspell expand_aliases extglob extquote force_fignore globstar hostcomplete interactive_comments progcomp promptvars sourcepath
do
  shopt -s $i 2>/dev/null
done

# }}}
# term {{{

# disable <C-S><C-Q>
stty -ixon -ixoff

# terminal mode
case `tty` in
 #/dev/pts/* ) stty erase '^H' intr '^C' kill '^@';;
  /dev/pts/* ) stty erase '^?' intr '^C' kill '^U';;
esac

# prompt
if [ `id -u` = "0" ]; then
  PS1='[\t] [\e[31m\u@\h: \w\a\e[0m] '
else
  PS1='[\t] [\u@\h: \w\a] '
fi

# unstated (*) stated (+)
export GIT_PS1_SHOWDIRTYSTATE=1
# stashed ($)
export GIT_PS1_SHOWSTASHSTATE=1
# untracked (%)
export GIT_PS1_SHOWUNTRACKEDFILES=1
# upstream (<=>)
export GIT_PS1_SHOWUPSTREAM="verbose"

COLOR_Y="\e[38;5;190m"
COLOR_G="\e[38;5;83m"
COLOR_G="\e[38;5;183m"
COLOR_R="\e[38;5;31m"
COLOR_W="\e[0m"
PROMPT_COMMAND='PS1="$COLOR_Y[\t] $COLOR_G[\u@\h: \w\a]$COLOR_R$(__git_ps1)$COLOR_W \n\$ "'

# }}}
# bash {{{

set glob_dot_filenames
set command_oriented_history
set horizontal-scroll-mode Off
set editing-mode vi
set -o vi
set cdable_vars
set hostname_completion_file="/etc/hosts"
shopt -s histappend
shopt -s checkwinsize

export FCEDIT=$EDITOR
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
export HISTCONTROL=ignoredups
export HISTFILE="$HOME/.history"
export HISTFILESIZE=5000
export HISTSIZE=5000

# }}}
# git {{{

# disable ssl verification
export GIT_SSL_NO_VERIFY=true

# }}}

