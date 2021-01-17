# Shell profile

# Export path.
if [ -d "${HOME}/bin" ]; then
	export PATH="${PATH}:${HOME}/bin"
fi
if [ -d "${HOME}/.local/bin" ]; then
	export PATH="${PATH}:${HOME}/.local/bin"
fi

# Set default programs to environment variables.
export TERMINAL="alacritty"
export EDITOR="nvim"
export VISUAL="emacs"
export BROWSER="firefox"
