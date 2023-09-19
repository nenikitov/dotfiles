autoload -U colors && colors
autoload -Uz add-zsh-hook

setopt PROMPT_SUBST


# Refresh prompt variables before prompt is drawn
_zsh_prompt_precmd() {
    if git_repo="$(git remote get-url origin 2> /dev/null)"; then
	git_repo="$(basename $git_repo .git) - $(git rev-parse --abbrev-ref HEAD)"
    else
        git_repo='not a repo'
    fi
}
add-zsh-hook precmd _zsh_prompt_precmd


#region PS1

# Top left PS1 elements
ps1_tl_elems=(
    "%{$fg[red]%}"     '%n'        # User
    "%{$reset_color%}" ' in '
    "%{$fg[yellow]%}"  '%~'        # Current working directory
    "%{$reset_color%}" ' ('
    "%{$fg[green]%}"   '$git_repo' # Information about git
    "%{$reset_color%}" ')'
)
# Bottom left PS1 elements
ps1_bl_elems=(
    "%{$fg[magenta]%}" '%#'        # Prompt character (% or #)
    "%{$reset_color%}" ' '
)
# Bottom right PS1 elements
ps1_br_elems=(
    "%{$fg[cyan]%}"    '%*'        # Date
    "%{$reset_color%}" ' '
    "%{$fg[blue]%}"    '%?'        # Output of the last command
    "%{$reset_color%}"
)

# Set up PS1
PS1=${(j::)ps1_tl_elems}$'\n'${(j::)ps1_bl_elems}
RPS1=${(j::)ps1_br_elems}

#endregion


#region PS2

# Left PS2 elements
ps2_l_elems=(
    "%{$fg[magenta]%}" '>'
    "%{$reset_color%}" ' '
)
# Right PS2 elements
ps2_r_elems=(
    "%{$fg[cyan]%}"    '%_'        # Scope
    "%{$reset_color%}"
)

# Set up PS2
PS2=${(j::)ps2_l_elems}
RPS2=${(j::)ps2_r_elems}

#endregion


#region PS3

# Left PS3 elements
ps3_elems=(
    "%{$fg[magenta]%}" '?'
    "%{$reset_color%}" ' '
)

# Set up PS3
PS3=${(j::)ps3_elems}

#endregion
