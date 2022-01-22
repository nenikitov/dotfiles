modules_path="${HOME}/.config/zsh/modules"


# Modules
# Completition
autoload -U compinit; compinit

autoload -U colors && colors

NEWLINE=$'\n'

source $modules_path/prompt.zsh