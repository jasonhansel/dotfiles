
#function ssh() {
#  # Force SSH to always get passwords and passphrases from SSH_ASKPASS, every time,
#  # and not from the TTY *or* from the agent.
#  if [[ -n "$SSH_CONNECTION" ]]
#  then
#    SSH_AUTH_SOCK= /usr/bin/ssh "$@"
#  else
#    SSH_AUTH_SOCK= SSH_ASKPASS=$HOME/bin/askpass SSH_TTY=`tty` setsid -w /usr/bin/ssh "$@"
#  fi
#}

# Misc. utilities
alias c='cat -v '
alias \?='man'

function restic() {
	( source /etc/restic/b2_env.sh ; /usr/bin/restic "$@" ; )
}

function gserver() {
  git init
  ssh server "git init ~/git-projects/$(basename $PWD)"
  git remote add server "server:~/git-projects/$(basename $PWD)"
  # Can't have the below because need to make a commit first
 # git push --mirror server
}

# Vim
alias vi='vim -O '
alias suvi='sudoedit ' # More secure than vim when used with sudo

# Pacman
alias pac='pacman'
alias supac='sudo pacman '
alias tri='trizen'

# Systemctl
alias sy='systemctl '
alias susy='sudo systemctl '
alias usy='systemctl --user'

# Journalctl
alias jo='journalctl -e '
alias sujo='sudo journalctl -e '
alias ujo='journalctl --user -e '

# Docker
alias sudocker='sudo docker '
alias sudc='sudo docker-compose '

# Colorize things...
alias diff='colordiff '
alias grep='grep --color'

# Git
alias st='git status'
alias am='git commit -am'
alias grv='git remote -v'

# Pass aliases to sudo properly
# See: https://wiki.archlinux.org/index.php/Sudo#Passing_aliases
alias sudo='sudo '

# "ls" variants
# For LC_COLLATE, see: http://superuser.com/questions/448291/
alias l='ls -F'
alias la='ls -FhA'
alias ll='LC_COLLATE=C ls -lhA '

# Stop doing stupid stuff
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -v'

# Options I always forget
alias pgrep='pgrep -af'

# Create a link in whichever direction works
function link() {
	if [[ -e $1 ]] ; then
		ln -sTv $1 $2
	elif [[ -e $2 ]] ; then
		ln -sTv $2 $1
	else
		echo Neither exist
	fi
}


# Make zsh know about hosts already accessed by SSH
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

