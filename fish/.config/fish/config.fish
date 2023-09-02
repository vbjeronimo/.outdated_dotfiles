set fish_greeting
set TERM "xterm-256color"
set EDITOR "nvim"

set -x STARSHIP_CONFIG ~/.config/starship/starship.toml

alias l="exa -l --icons --group-directories-first"
alias ll="exa -la --icons --group-directories-first --git"
alias t="exa -T --icons"
alias tt="exa -Ta --icons"
alias md="mkdir -p"

starship init fish | source
