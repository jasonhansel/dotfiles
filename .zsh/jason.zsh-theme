# ZSH PROMPT THEME
# Based on the "risto" and "afowler" themes from oh-my-zsh.

source ~/.tmux-color.sh
ZCOLOR=${(l:3::0:)color}
MOUSEOFF=$(printf "\e[?1000l")
MOUSEOFF=$(printf "\e[?1000l")
MOUSEOFF=""

PROMPT='${MOUSEOFF}%(?..%{$fg[red]%}%? %{$reset_color%})%{$FG[$ZCOLOR]%}%n@%M %{$fg_bold[blue]%}%2~ $(git_prompt_info)%{$reset_color%}» '
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%} "
