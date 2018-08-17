# Configure paths.
export GOPATH=~/go
export PATH=$HOME/bin:/usr/local/bin:$PATH
export RUST_BACKTRACE=1


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
antigen bundle unixorn/autoupdate-antigen.zshplugin


# Load oh-my-zsh's tmux plugin. Don't autoconnect to tmux -- my custom
# package will take care of this.
ZSH_TMUX_AUTOCONNECT=false
antigen bundle tmux

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
setopt nobgnice
setopt appendcreate
setopt shortloops

bindkey -r "^Q"
bindkey -r "^O"
bindkey " " self-insert

# Override
export _ZSH_TMUX_FIXED_CONFIG="$HOME/.tmux.conf"

