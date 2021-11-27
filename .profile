# Shell profile

# Export path.

# Scripts and local binaries.
if [ -d "$HOME/bin" ]; then
	export PATH="$PATH:$HOME/bin"
fi
if [ -d "$HOME/.local/bin" ]; then
	export PATH="$PATH:$HOME/.local/bin"
fi

# Set environment variables.

# Set default programs.
export TERMINAL="alacritty"
export PAGER="less"
export EDITOR="nvim"
export BROWSER="brave"
