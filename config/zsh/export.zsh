export CDPATH=.:~:~/Projects:~/Code:~/GitHub
export LC_ALL="en_US.UTF-8"
export GOPATH=$HOME/.go
export SHELL=/opt/homebrew/bin/zsh

# local node_bin_path="$HOME/.asdf/installs/nodejs/lts/.npm/bin"
# PATH="$HOME/.config/bin:./bin:$HOME/local/node/npm/bin:$node_bin_path:/usr/local/sbin:$GOPATH/bin:$HOME/.yarn/bin:$HOME/.cargo/bin:$PATH"
PATH="$HOME/.config/bin:./bin:$HOME/local/node/npm/bin:/usr/local/sbin:$GOPATH/bin:$HOME/.yarn/bin:$HOME/.cargo/bin:$PATH"

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
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --color=selected-bg:#45475a \
    --multi"
else
  export TERM_IS_DARK="false"
  export BAT_THEME="Catppuccin Latte"
  export FZF_DEFAULT_OPTS=" \
    --color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
    --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
    --color=marker:#7287fd,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39 \
    --color=selected-bg:#bcc0cc \
    --multi"
fi
