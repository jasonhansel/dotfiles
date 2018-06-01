# Loosely based on: https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/common-aliases/common-aliases.plugin.zsh

alias c='cat -v '
alias vi='vim -O '

alias pac='pacman'
alias supac='sudo pacman '
alias tri='trizen'

alias susy='sudo systemctl '
alias sy='systemctl '
alias usy='systemctl --user'
alias \?='man'

alias sujo='sudo journalctl -e '
alias jo='journalctl -e '
alias ujo='journalctl --user -e '


alias up='cd ..'


alias suvi='sudoedit ' # More secure than vim when used with sudo
alias sudocker='sudo docker '
alias sudc='sudo docker-compose '

# Git
alias gls='git ls-tree --name-only -r HEAD'
alias st='git status'
alias am='git commit -am'

# Pass aliases to sudo properly
# See: https://wiki.archlinux.org/index.php/Sudo#Passing_aliases
alias sudo='sudo '

# "ls" variants
# For LC_COLLATE, see: http://superuser.com/questions/448291/
alias l='ls -F'
alias la='ls -FhA'
alias ll='LC_COLLATE=C ls -lhA '

alias grep='grep --color'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -v'

# Create a link in whichever direction works
function link()
{
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

# Put a separator on the terminal
# Makes tmux scrollback more readable
function separator()
{
	echo
	printf '%*s\n' ${COLUMNS:-$(tput cols)} | sed -e $'s/ /\u2501/g'
	echo
}

# "ls" but with unix permissions for each file
# See: http://stackoverflow.com/questions/1795976/
function lsn ()
{
	ls -l $* | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf("%0o ",k);print}'
}
