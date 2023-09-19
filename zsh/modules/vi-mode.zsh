# Disable vim mode
set -o emacs

# Edit in default editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

