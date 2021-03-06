# environment variables for zsh
local pathadds

# history
HISTFILE=~/.zsh_history
HISTSIZE=1000000000
SAVEHIST=1000000000
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY

# prompt command time
ZSH_COMMAND_TIME_MIN=60
ZSH_COMMAND_TIME_EXCLUDE=(v vim nvim sudoedit chm chezmoi)

# ruby
path=("$HOME/.local/share/gem/ruby/3.0.0/bin" $path)
export GEM_HOME=$HOME/gems

# other
export SSH_KEY_PATH=$HOME/.ssh/id_rsa
export LANG=en_US.UTF-8
export EDITOR='nvim'

# rust
path=("$HOME/.cargo/bin" $path)

# path
path=("$HOME/bin" '/usr/local/bin' $path)
export PATH

