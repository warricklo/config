# Bash configuration

# Set prompt.
PS1="\[\033[38;5;3m\][\u@\h \w]\[\033[0m\] \$ "

# History file configuration.
shopt -s histappend
HISTSIZE=100000
HISTFILESIZE=100000
HISTFILE="$XDG_CACHE_HOME/bash/history"

# GPG.
export GPG_TTY="$(tty)"

# Load aliases.
if [ -f "$XDG_CONFIG_HOME/aliasrc" ]; then
	source "$XDG_CONFIG_HOME/aliasrc"
fi
