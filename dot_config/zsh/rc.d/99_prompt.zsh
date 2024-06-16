# prompt for zsh

autoload -Uz vcs_info
setopt prompt_subst

local return_code="%(?..%B%F{1}%? %f%b)"
local hostname="%F{6}%m%f"
local current_dir="%F{4}%(4~|%-1~/…/%2~|%3~)%f"
local shell_level="%(2L.%F{13}[%L]%f .)"

function precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats ' %F{3}(%b%m%u%c)%f'
zstyle ':vcs_info:git:*' actionformats ' %F{12}[%F{9}%a%F{12}]%b%m%F{12}%u%c%f '
zstyle ':vcs_info:git:*' patch-format ' %F{3}@%F{10}%1.10p%F{3}(%F{6}%n%F{3}/%F{6}%a%F{3})'
zstyle ':vcs_info:git:*' nopatch-format ' %F{3}(%F{6}%n%F{3}/%F{6}%a%F{3})'
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

PROMPT="%F{8}#%f ${shell_level}${return_code}${hostname} ${current_dir}\$vcs_info_msg_0_
; "

export VIRTUAL_ENV_DISABLE_PROMPT=1
