# LS_COLORS theme selection
#
# To skip setting those themes, set $SKIP_LS_COLORS before this file,
# like in ~/.local/zsh/*.pre.zsh .

if [ -z "$SKIP_LS_COLORS" ]; then 
    [ -e "$HOME/.config/lscolours/8bit" ] && \
    [ "x$(tput colors 2>/dev/null)" = "x256" ] && \
    source $HOME/.config/lscolours/8bit; return

    [ -e "$HOME/.config/lscolours/4bit" ] && \
    source $HOME/.config/lscolours/4bit
fi

