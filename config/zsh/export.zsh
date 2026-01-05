export TMUX_TMPDIR=/tmp

export CDPATH=.:~:~/Projects:~/Code:~/GitHub
export LC_ALL="en_US.UTF-8"
export GOPATH=$HOME/.go
export SHELL=/opt/homebrew/bin/zsh

# local node_bin_path="$HOME/.asdf/installs/nodejs/lts/.npm/bin"
# PATH="$HOME/.config/bin:./bin:$HOME/local/node/npm/bin:$node_bin_path:/usr/local/sbin:$GOPATH/bin:$HOME/.yarn/bin:$HOME/.cargo/bin:$PATH"
PATH="./bin:$HOME/.config/bin:$HOME/local/node/npm/bin:/usr/local/sbin:$GOPATH/bin:$HOME/.yarn/bin:$HOME/.cargo/bin:$PATH"

export DOCKER_CLIENT_TIMEOUT=120
export COMPOSE_HTTP_TIMEOUT=120

export RUST_WITHOUT=rust-docs

export RUBY_YJIT_ENABLE=1

export LG_CONFIG_FILE="$HOME/Library/Application Support/lazygit/config.yml,$HOME/.cache/nvim/lazygit-theme.yml"

# Set some config if MacOS is running on Dark mode
if [[ $(defaults read -g AppleInterfaceStyle 2>/dev/null) == "Dark" ]]; then
  export TERM_IS_DARK="true"
  export BAT_THEME="Catppuccin Mocha"
  export FZF_DEFAULT_OPTS=" \
    --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
    --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
    --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
    --color=selected-bg:#45475A \
    --color=border:#6C7086,label:#CDD6F4"
else
  export TERM_IS_DARK="false"
  export BAT_THEME="Catppuccin Latte"
  export FZF_DEFAULT_OPTS=" \
    --color=bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39 \
    --color=fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78 \
    --color=marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39 \
    --color=selected-bg:#BCC0CC \
    --color=border:#9CA0B0,label:#4C4F69"
fi

export GPG_TTY=$(tty)
