# ZSH PROMPT THEME
# Based on the "risto" and "afowler" themes from oh-my-zsh.

PROMPT='%(?..%{$fg[red]%}%? %{$reset_color%})%{$fg[green]%}%n@%M %{$fg_bold[blue]%}%2~ $(git_prompt_info)%{$reset_color%}» '
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%} "
