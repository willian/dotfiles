export CDPATH=.:~:~/Projects:~/Code:~/GitHub
export LC_ALL="en_US.UTF-8"
export GOPATH=$HOME/.go
export SHELL=/usr/local/bin/zsh

local node_bin_path="$HOME/.asdf/installs/nodejs/lts/.npm/bin"
PATH="$HOME/.config/bin:./bin:$HOME/local/node/npm/bin:$node_bin_path:/usr/local/sbin:$GOPATH/bin:$HOME/.yarn/bin:$HOME/.cargo/bin:$HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin:$PATH"

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_R_OPTS="--reverse"
export FZF_TMUX_OPTS="-p"

export DOCKER_CLIENT_TIMEOUT=120
export COMPOSE_HTTP_TIMEOUT=120

export BAT_THEME=Catppuccin-mocha

export RUST_WITHOUT=rust-docs
