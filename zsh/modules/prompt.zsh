prompt_tl_elems=(
    '%n'
    ' in '
    '%~'
)
prompt_bl_elems=(
    '%#'
    ' '
)
prompt_tr_elems=(
    ' '
)
prompt_br_elems=(
    ' '
)

PS1=${(j::)prompt_tl_elems}$'\n'${(j::)prompt_bl_elems}