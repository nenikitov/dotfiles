modules_path="${HOME}/.config/zsh/modules"

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# TTY Color scheme
#source "${modules_path}/tty-colorscheme.zsh"

# Prompt
source "${modules_path}/prompt.zsh"

# Aliases and exports
source "${modules_path}/exports.zsh"
source "${modules_path}/aliases.zsh"

# VI-mode
source "${modules_path}/vi-mode.zsh"

# Completition
source "${modules_path}/completion.zsh"

# Suggestions
source "${modules_path}/suggestions.zsh"

# Syntax highlighting
source "${modules_path}/highlighting.zsh"

# Dynamic title
source "${modules_path}/title.zsh"
