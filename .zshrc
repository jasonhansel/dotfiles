# Configure paths.
export GOPATH=~/go
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export RUST_BACKTRACE=1

export SCALA_HOME=/usr/share/scala


export DISABLE_AUTO_TITLE=false
export AUTO_TITLE=true

export LEDGER_FILE=/home/jason/ledger/data.journal
export LEDGER_SORT=date
export LEDGER_ADD_BUDGET=1

# Keep prompt at bottom of screen [issue: window resize]
# printf '\n%.0s' {2..$LINES}

# Don't try to cache completions.
# See https://wiki.archlinux.org/index.php/zsh
zstyle ':completion:*' rehash true

# Load antigen package manager. Assumes that antigen was installed
# through the Arch Linux AUR.
source /usr/share/zsh/share/antigen.zsh

autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic



# Enable oh-my-zsh within antigen.
antigen use oh-my-zsh

# Load a few oh-my-zsh packages.
antigen bundle gitfast
antigen bundle docker
antigen bundle systemd
antigen bundle djui/alias-tips
antigen bundle zdharma/fast-syntax-highlighting
antigen bundle unixorn/autoupdate-antigen.zshplugin


# Load oh-my-zsh's tmux plugin. Don't autoconnect to tmux -- my custom
# package will take care of this.
# ZSH_TMUX_AUTOCONNECT=false
# antigen bundle tmux

antigen bundle --no-local-clone $HOME/.zsh

# Load custom theme
# antigen theme ~/.zsh jason --no-local-clone

# Commit the antigen changes.
antigen apply

# Load aliases
# source ~/.zsh/aliases.zsh
source ~/.zsh/jason.zsh-theme

setopt nosharehistory
setopt noincappendhistory
setopt noflowcontrol

bindkey -M isearch '^[OA' history-incremental-search-backward
bindkey -M isearch '^[OB' history-incremental-search-forward
bindkey -M isearch '\e' accept-search

setopt nobgnice
setopt appendcreate
setopt shortloops

bindkey -r "^Q"
bindkey -r "^O"
bindkey " " self-insert



# Override
export DISABLE_AUTO_TITLE="false"
export AUTO_TITLE=true
export _ZSH_TMUX_FIXED_CONFIG="$HOME/.tmux.conf"
export SSH_ASKPASS=$HOME/bin/askpass

# Fix syntax highlighting

source $HOME/.antigen/bundles/zdharma/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
typeset -A FAST_HIGHLIGHT_STYLES
FAST_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
FAST_HIGHLIGHT_STYLES[command]='none'
FAST_HIGHLIGHT_STYLES[builtin]='none'
FAST_HIGHLIGHT_STYLES[alias]='none'
FAST_HIGHLIGHT_STYLES[unknown-token]='none'
FAST_HIGHLIGHT_STYLES[arg0]='none'

alias config='GIT_DIR=$HOME/.cfg/ GIT_WORK_TREE=$HOME git'

# Start "tmux", if necessary
source ~/.zsh/start-tmux.zsh

