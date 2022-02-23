# Basic vi mode
bindkey -v
export KEYTIMEOUT=1

# Cursor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line
