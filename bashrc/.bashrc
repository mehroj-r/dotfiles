# init tools
eval "$(starship init bash)"

. "$HOME/.rye/env"
. "$HOME/.local/bin/env"
eval "$(uv generate-shell-completion bash)"
