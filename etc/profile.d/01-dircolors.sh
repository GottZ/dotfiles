#if [[ -r "$HOME/.dircolors" ]]; then
#	eval "$(dircolors -b "$HOME/.dircolors")"
#elif [[ -r "/etc/DIR_COLORS" ]]; then
#	eval "$(dircolors -b "/etc/DIR_COLORS")"
#else
#	eval "$(dircolors -b)"
#fi
#
#export LS_COLORS
#
#DIR_COLORS="${LS_COLORS}"
#export DIR_COLORS

# /usr/local/bin/dircolors takes care of this now.
eval export "$(dircolors -b)"
