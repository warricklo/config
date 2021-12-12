# Shell profile

# Export path.

# Scripts and local binaries.
if [ -d "$HOME/bin" ]; then
	export PATH="$PATH:$HOME/bin"
fi

# Set environment variables.

# XDG base directories.
export XDG_CONFIG_HOME="$HOME/etc"
export XDG_CACHE_HOME="$HOME/var/cache"
export XDG_DATA_HOME="$HOME/usr/share"
export XDG_STATE_HOME="$HOME/var/lib"

# Set default programs.
export TERMINAL="alacritty"
export PAGER="less"
export EDITOR="nvim"
export BROWSER="brave"

# Clean up home folder.
# Refer to <https://wiki.archlinux.org/title/XDG_Base_Directory>.

export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
