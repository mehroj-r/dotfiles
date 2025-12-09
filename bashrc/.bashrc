# init tools
eval "$(starship init bash)"

. "$HOME/.rye/env"
. "$HOME/.local/bin/env"
eval "$(uv generate-shell-completion bash)"

# Django
alias dj="python manage.py"

# Git
. "$HOME/.git-aliases"

export PATH="$HOME/development/flutter/bin/:$PATH"
export PATH="$PATH":"$HOME/.pub-cache/bin"
export EDITOR=nvim

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
