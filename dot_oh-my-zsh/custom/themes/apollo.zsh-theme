# vim: set ft=zsh:

autoload -U colors && colors
eval PINK='$FG[175]'
local return_code="%(?..%{$fg[red]%}↵ %? %{$reset_color%})"

if [[ $UID -eq 0 ]]; then
    local user_host='%{$fg[red]%}%n@%m %{$reset_color%}'
    local user_symbol='#'
else
    local user_host='%{$PINK%}%n@%m %{$reset_color%}'
    local user_symbol='☉'
fi

local current_dir='%{$fg[blue]%}%(4~|%-1~/…/%2~|%3~) %{$reset_color%}'
local git_branch='$(git_prompt_info)'
local venv_prompt='$(virtualenv_prompt_info)'

PROMPT="%B${return_code}%b${user_host}${current_dir}${venv_prompt}${git_branch}
%B${user_symbol}%b "

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"

ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX="%{$fg[green]%}«"
ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="» %{$reset_color%}"
ZSH_THEME_VIRTUALENV_PREFIX=$ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX
ZSH_THEME_VIRTUALENV_SUFFIX=$ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX
