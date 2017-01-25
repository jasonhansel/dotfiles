# Based on the oh-my-zsh plugin, whose autostart feature
# doesn't work for me. Specifically, the prompt doesn't
# work after exiting tmux if I use the plugin.

if [[ ! -n "$TMUX" ]] 
then 
	if [[ "$ZSH_TMUX_AUTOSTARTED" != "true" ]] 
	then 
		export ZSH_TMUX_AUTOSTARTED=true 
		tmux attach || tmux new-session
	fi
fi
