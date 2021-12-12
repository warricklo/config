# Zsh configuration

# Set colors.
autoload -U colors
colors

# Set prompt.
PS1="%F{3}[%n@%m %~]%f %(?..%B%F{9}%?%f%b )%(!.#.$) "

# History file configuration.
setopt hist_ignore_dups
SAVEHIST=100000
HISTSIZE=100000
HISTFILE="$XDG_CACHE_HOME/zsh/history"

# Enable tab completion.
autoload -U compinit
zstyle ":completion:*" menu select
zmodload zsh/complist
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

# Do not ask before executing 'rm *' or 'rm path/*'.
setopt rm_star_silent

# vi-like bindings.
bindkey -v "^?" backward-delete-char

# GPG.
export GPG_TTY="$(tty)"

# Load aliases.
if [ -f "$XDG_CONFIG_HOME/aliasrc" ]; then
	source "$XDG_CONFIG_HOME/aliasrc"
fi

# Load Zsh scripts.

autosuggestions="$XDG_DATA_HOME/zsh/autosuggestions/zsh-autosuggestions.zsh"
syntax_highlight="$XDG_DATA_HOME/zsh/syntax-highlighting/zsh-syntax-highlighting.zsh"

if [ -f "$autosuggestions" ]; then
	source "$autosuggestions"
fi

if [ -f "$syntax_highlight" ]; then
	source "$syntax_highlight"
fi

unset autosuggestions
unset syntax_highlight
