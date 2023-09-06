set fish_greeting
set TERM "xterm-256color"
set EDITOR "nvim"

set -x STARSHIP_CONFIG ~/.config/starship/starship.toml

set -U fish_user_paths $HOME/.local/bin $fish_user_paths
set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths

alias l="exa -l --icons --group-directories-first"
alias ll="exa -la --icons --group-directories-first --git"
alias t="exa -T --icons"
alias tt="exa -Ta --icons"
alias md="mkdir -p"

pyenv init - | source
starship init fish | source
