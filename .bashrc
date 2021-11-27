# Bash configuration

# Set prompt.
PS1="\[\033[38;5;3m\][\u@\h \w]\[\033[0m\] \$ "

# History file configuration.
shopt -s histappend
HISTSIZE=100000
HISTFILESIZE=100000
HISTFILE="$HOME/.cache/bash/history"

# GPG.
export GPG_TTY="$(tty)"

# Load aliases.
if [ -f "$HOME/.config/aliasrc" ]; then
	source "$HOME/.config/aliasrc"
fi
