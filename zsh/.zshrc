modules_path="${HOME}/.config/zsh/modules"
plugins_path="/usr/share/zsh/plugins"

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history


# Prompt
source $modules_path/prompt.zsh

# Path
export PATH=$HOME/.cargo/bin:$PATH

# Aliases and exports
source $modules_path/exports.zsh
source $modules_path/aliases.zsh

# VI-mode
source $modules_path/vi-mode.zsh

# Completition
source $modules_path/completion.zsh

# Syntax highlighting
source $plugins_path/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

