# prompt for zsh

autoload -Uz vcs_info
setopt prompt_subst

local return_code="%(?..%B%F{1}↵ %? %f%b)"

local user_colour user_symbol
typeset -A symbols
symbols=( \
        'apollo' '☉' \
        'feoh' 'ᚠ' \
        'prometheus' '⚢' \
        )

if [[ $UID -eq 0 ]]; then
    user_colour='1'
    user_symbol='#'
elif [[ ! -z $HOST ]]; then
    user_colour='5'
    [[ ! -z $symbols[${HOST%%.*}] ]] && user_symbol=$symbols[${HOST%%.*}] || user_symbol='$'
else
    user_colour='5'
    user_symbol='$'
fi

local user_host="%B%F{$user_colour}%}%n%b%F{6}@%m%f"

local current_dir="%F{4}%(4~|%-1~/…/%2~|%3~)%f"

function precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats ' %F{3}g:%b%m%u%c%f'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

+vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
       git status --porcelain | grep -m 1 '^??' &>/dev/null
    then
        hook_com[misc]='?'
    else
        hook_com[misc]=''
    fi
}

function venv_prompt_info() {
    [[ -n "$VIRTUAL_ENV" ]] && echo " %F{2}v:${VIRTUAL_ENV##*/}%f"
}

PROMPT="${return_code}${user_host} ${current_dir}\$(venv_prompt_info)\$vcs_info_msg_0_
%B${user_symbol}%b "

export VIRTUAL_ENV_DISABLE_PROMPT=1
