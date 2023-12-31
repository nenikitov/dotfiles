" Vim syntax file
" Language: Marie assembly
" Maintainer: nenikitov
" Latest revision: 2023-11-15

" if exists("b:current_syntax")
"     finish
" endif

let b:current_syntax = "mas"
set tabstop=8
set shiftwidth=8
set noexpandtab

" Syntax
syn match masAddress '\w\+'
syn match masNumber '\d\+'
syn match masComment "/.*$"
syn match masLabel "^\w\+"
syn match masComma ","
syn keyword masNumberSkip 000 400 800
syn keyword masOrg ORG END nextgroup=masNumber skipwhite
syn keyword masInstruction Clear Input Output StoreI LoadI Halt
syn keyword masInstructionAddress Add Subt AddI Load Store JnS JumpI nextgroup=masAddress skipwhite
syn keyword masInstructionLabel Jump nextgroup=masLabel skipwhite
syn keyword masInstructionSkip Skipcond nextgroup=masNumberSkip skipwhite
syn keyword masNumberType Dec Hex nextgroup=masNumber skipwhite

" Highlights
hi def link masComment Comment
hi def link masInstruction Function
hi def link masInstructionAddress Function
hi def link masInstructionLabel Function
hi def link masInstructionSkip Function
hi def link masOrg Keyword
hi def link masAddress Identifier
hi def link masLabel Label
hi def link masNumberType Type
hi def link masNumber Number
hi def link masNumberSkip String
hi def link masComma Delimiter
