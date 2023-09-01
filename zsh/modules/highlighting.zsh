plugins_path="/usr/share/zsh/plugins"

# Define variables
typeset -A ZSH_HIGHLIGHT_PATTERNS
typeset -A ZSH_HIGHLIGHT_STYLES


# Enable more hihglighting modules
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)


#region Main colors

# Commands
ZSH_HIGHLIGHT_STYLES[precommand]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[command]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[alias]='fg=blue'
ZSH_HIGHLIGHT_STYLES[function]='fg=blue'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=none'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=cyan,underline'
# Arguments
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=red'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=red'
# File arguments
ZSH_HIGHLIGHT_STYLES[path]='fg=yellow,underline'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=yellow,bold,underline'
# "String" arguments
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=red,bold,underline'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=red,bold,underline'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=red,bold,underline'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=red'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=cyan'
# Command substitution
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=white'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=white'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=red,bold,underline'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=white'
# Other
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold,underline'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[default]='fg=cyan'

#endregion

#region Brackets

ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=magenta,bold'

#endregion


# Enable syntax highlighting
source $plugins_path/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
