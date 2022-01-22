prompt_top_left_elems=(
    '%n'
    ' in '
    '%~'
)
prompt_bottom_left_elems=(
    '%#'
    ' '
)

PS1=${(j::)prompt_top_left_elems}$'\n'${(j::)prompt_bottom_left_elems}