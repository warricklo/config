# Bash configuration

# Set prompt.
export PS1="\[\033[38;5;14m\]\w\[\033[0m\] \[\033[38;5;12m\]\$\[\033[0m\] "

# GPG.
export GPG_TTY=$(tty)

# Load aliases.
if [ -f "$HOME/.config/aliasrc" ]; then
	source "$HOME/.config/aliasrc"
fi
