if [[ -r "$HOME/.local/bin" ]]; then
	append_path "$HOME/.local/bin"
fi

if [[ -r "$HOME/go/bin" ]]; then
	append_path "$HOME/go/bin"
fi

if [[ -r "/opt/dotfiles/.bin" ]]; then
	append_path "/opt/dotfiles/.bin"
fi

if [[ -r "$HOME/.cargo/env" ]]; then
	. "$HOME/.cargo/env"
fi

export PATH

