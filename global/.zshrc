# Configure paths.
export GOPATH=~/go
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Don't try to cache completions.
# See https://wiki.archlinux.org/index.php/zsh
zstyle ':completion:*' rehash true

# Load antigen package manager. Assumes that antigen was installed
# through the Arch Linux AUR.
source /usr/share/zsh/share/antigen.zsh

# Enable oh-my-zsh within antigen.
antigen use oh-my-zsh

# Load a few oh-my-zsh packages.
antigen bundle gitfast
antigen bundle common-aliases
antigen bundle archlinux
antigen bundle systemd
antigen bundle npm
antigen bundle djui/alias-tips


# Load oh-my-zsh's tmux plugin. Don't autoconnect to tmux -- my custom
# package will take care of this.
ZSH_TMUX_AUTOCONNECT=false
antigen bundle tmux

# Load custom theme
antigen theme ~/.zsh jason --no-local-clone

# Commit the antigen changes.
antigen apply

# Load aliases
source ~/.zsh/aliases.zsh

# Don't try to share history between zsh sessions.
setopt nosharehistory noincappendhistory

setopt correct
# See https://news.ycombinator.com/item?id=9752238 for details.
setopt noflowcontrol

setopt nobgnice
setopt appendcreate
setopt shortloops


# Override
export _ZSH_TMUX_FIXED_CONFIG="$HOME/.tmux.conf"

# Start "tmux", if necessary
source ~/.zsh/start-tmux.zsh
