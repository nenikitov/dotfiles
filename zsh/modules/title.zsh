autoload -Uz add-zsh-hook

title_elems=(
    "${TERM}"
    " "
    '$(pwd)'
    " "
    '${command}'
)

command=""

function _update_title() {
    local command="${1}"
    local title=""

    for elem in "${title_elems[@]}"; do
        if [[ "${elem}" =~ \\$ ]]; then
            elem=$(eval echo $elem)
        fi
        title+="${elem}"
    done
    title="${title/$HOME/~}"

    echo -ne "\033]0;${title}\007"
}

function _zsh_title_preexec() {
    input=${1//\\/\\\\\\\\}
    command=(${(z)input})

    _update_title ${command}
}

add-zsh-hook preexec _zsh_title_preexec
_update_title

