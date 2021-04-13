# environment variables for zsh
local pathadds

# history
HISTFILE=~/.zsh_history
HISTSIZE=1000000000
SAVEHIST=1000000000
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

# ruby
path=("$HOME/gems/bin" "$HOME/.gem/ruby/2.7.0/bin" $path)
export GEM_HOME=$HOME/gems

# other
export SSH_KEY_PATH=$HOME/.ssh/id_rsa
export LANG=en_US.UTF-8
export EDITOR='nvim'

# path
path=("$HOME/bin" '/usr/local/bin' $path)
export PATH

