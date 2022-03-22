# List all files with colors
alias ls='exa --color=always -aF --group-directories-first --'
# List all files with colors in long format with extra git info
alias ll='exa --color=always -laFgh --group-directories-first --git --time-style=long-iso --icons --'

# Easy clear
alias c='clear'
# Better date format by default
alias idate='date +"%A, %Y-%m-%d %H:%M:%S"'
alias ical='cal -m -w -3'


# Safety (prompt before overwrite)
alias mv='mv -i'
alias rm='rm -i'
alias cp='cp -i'


# Send 5 packets and stop
alias ping='ping -c 5' 
# Automatically create subdirectories
alias mkdir='mkdir -pv'
# Bat command with better colors
alias bat='bat --theme base16 --paging always'


# Add more colors to default commands
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias less='less -R'
alias man="env \
        LESS_TERMCAP_md=$'\e[01;31m' \
        LESS_TERMCAP_me=$'\e[0m' \
        LESS_TERMCAP_us=$'\e[01;32m' \
        LESS_TERMCAP_ue=$'\e[0m' \
        LESS_TERMCAP_so=$'\e[01;43m' \
        LESS_TERMCAP_se=$'\e[0m' \
    man '$@'"
