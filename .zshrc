# Zsh configuration

# Set colors.
autoload -U colors
colors

# Set prompt.
export PS1="%{${fg[cyan]}%}%~%{${reset_color}%} %{${fg[blue]}%}$%{${reset_color}%} "

# History file configuration.
HISTSIZE=100000
SAVEHIST=100000
HISTFILE="$HOME/.cache/zsh/history"
setopt hist_ignore_dups

# History command wrapper.
history() {
	local clear
	zparseopts -E c=clear

	if [ -n "$clear" ]; then
		:> "$HISTFILE"
	else
		builtin history "$@"
	fi
}

# Enable tab completion.
autoload -U compinit
zstyle ":completion:*" menu select
zmodload zsh/complist
compinit

# Do not ask before executing `rm *` or `rm path/*`.
setopt rm_star_silent

# vi-like bindings.
bindkey -v "^?" backward-delete-char
export KEYTIMEOUT=1

# GPG.
export GPG_TTY=$(tty)

# Load aliases.
if [ -f "$HOME/.config/aliasrc" ]; then
	source "$HOME/.config/aliasrc"
fi

# Load zsh autosuggestions.
if [ -f "$HOME/.local/share/zsh/autosuggestions/zsh-autosuggestions.zsh" ]; then
	source "$HOME/.local/share/zsh/autosuggestions/zsh-autosuggestions.zsh"
fi

# Load zsh syntax highlighting.
# This command must be at the end of the configuration file.
if [ -f "$HOME/.local/share/zsh/syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
	source "$HOME/.local/share/zsh/syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
