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
HISTFILE="$HOME/.cache/zsh/history"

# Enable tab completion.
autoload -U compinit
zstyle ":completion:*" menu select
zmodload zsh/complist

# Do not ask before executing 'rm *' or 'rm path/*'.
setopt rm_star_silent

# vi-like bindings.
bindkey -v "^?" backward-delete-char

# GPG.
export GPG_TTY="$(tty)"

# Load aliases.
if [ -f "$HOME/.config/aliasrc" ]; then
	source "$HOME/.config/aliasrc"
fi

# Load Zsh scripts.

autosuggestions="$HOME/.local/share/zsh/autosuggestions/zsh-autosuggestions.zsh"
syntax_highlight="$HOME/.local/share/zsh/syntax-highlighting/zsh-syntax-highlighting.zsh"

if [ -f "$autosuggestions" ]; then
	source "$autosuggestions"
fi

if [ -f "$syntax_highlight" ]; then
	source "$syntax_highlight"
fi

unset autosuggestions
unset syntax_highlight
