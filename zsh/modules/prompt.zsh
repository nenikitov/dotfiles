autoload -U colors && colors
setopt PROMPT_SUBST

precmd() {
    if git_repo="$(git remote get-url origin 2> /dev/null)"; then
	git_repo="$(basename $git_repo .git) - $(git rev-parse --abbrev-ref HEAD)"
    else
        git_repo='not a repo'
    fi
    curr_date="$(date +%H:%M:%S)"
}

prompt_tl_elems=(
    "%{$fg[red]%}"     '%n'
    "%{$reset_color%}" ' in '
    "%{$fg[yellow]%}"  '%~'
    "%{$reset_color%}" ' ('
    "%{$fg[green]%}"   '$git_repo'
    "%{$reset_color%}" ')'
)
prompt_bl_elems=(
    "%{$fg[magenta]%}" '%#'
    "%{$reset_color%}" ' '
)
prompt_br_elems=(
    "%{$fg[cyan]%}"    '$curr_date'
    "%{$reset_color%}" ' '
    "%{$fg[blue]%}"    '%?'
    "%{$reset_color%}"
)


PS1=${(j::)prompt_tl_elems}$'\n'${(j::)prompt_bl_elems}
RPS1=${(j::)prompt_br_elems}

