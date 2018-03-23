# "less" alias
alias c='less -e ' # -F results in one-page files not being shown at all

# Sudo stuff
alias supac='sudo pacman '
alias susy='sudo systemctl '
alias sy='systemctl '
alias usy='systemctl --user'
alias sujo='sudo journalctl -e '
alias jo='journalctl -e '
alias ujo='journalctl --user -e '
alias suvi='sudoedit ' # More secure than vim when used with sudo
alias sudocker='sudo docker '

# Git
alias gls='git ls-tree --name-only -r HEAD'
alias ginit='git init --bare'

# Misc
alias pac='pacman'

# Systemd
alias jc='journalctl'
alias sc='systemctl'

# Pass aliases to sudo properly
# See: https://wiki.archlinux.org/index.php/Sudo#Passing_aliases
alias sudo='sudo '

# "ls" variants
# For LC_COLLATE, see: http://superuser.com/questions/448291/
alias l='ls -F'
alias la='ls -FhA'
alias ll='LC_COLLATE=C ls -lhA '
alias lc='ls++ --potsf '

alias linkto='ln -sT'

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
