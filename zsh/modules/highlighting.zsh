plugins_path="/usr/share/zsh/plugins"

# Define variables
typeset -A ZSH_HIGHLIGHT_PATTERNS
typeset -A ZSH_HIGHLIGHT_STYLES


# Enable more hihglighting modules
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)


# Set main colors
ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'


# Enable highlighting
source $plugins_path/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
