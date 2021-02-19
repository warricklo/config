# Shell profile

# Export path

# Scripts and local binaries.
if [ -d "$HOME/bin" ]; then
	export PATH="$PATH:$HOME/bin"
fi
if [ -d "$HOME/.local/bin" ]; then
	export PATH="$PATH:$HOME/.local/bin"
fi

# Doom Emacs binaries.
if [ -d "$HOME/.emacs.d/bin" ]; then
	export PATH="$PATH:$HOME/.emacs.d/bin"
fi

# Environment variables

# Set default programs.
export TERMINAL="alacritty"
export PAGER="less"
export EDITOR="nvim"
export VISUAL="emacs"
export BROWSER="brave"

# Rust env vars.
source "$HOME/.cargo/env"
