autoload -U compinit


# Case insensitive completion that also matches incomplete file names
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Cycle through options as a menu
zstyle ':completion:*' menu select 

# Group results
zstyle ':completion:*' group-name ''
# Colors for groups
zstyle ':completion:*:descriptions' format '%F{blue}--- %d ---%f'
zstyle ':completion:*:corrections' format '%F{yellow}?-- %d --?%f'
zstyle ':completion:*:messages' format '%F{cyan}#-- %d --#%f'
zstyle ':completion:*:warnings' format '%F{red}!-- no matches found --!%f'


# Init the completion
zmodload zsh/complist
compinit


# Show hidden files in the completion list
_comp_options+=(globdots)

