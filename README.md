# Dotfiles

Personal macOS configuration files managed with [rcm](https://github.com/thoughtbot/rcm).

## What's Included

### Shell (Zsh)

- [Zim](https://zimfw.sh/) plugin manager with autosuggestions and syntax highlighting
- [Starship](https://starship.rs/) prompt
- [fzf](https://github.com/junegunn/fzf) for fuzzy finding
- [mise](https://mise.jdx.dev/) for runtime version management

### Terminal & Multiplexer

- [WezTerm](https://wezfurlong.org/wezterm/) terminal emulator
- [tmux](https://github.com/tmux/tmux) with vim-style navigation and [sesh](https://github.com/joshmedeski/sesh) session management
- [lazygit](https://github.com/jesseduffield/lazygit) and [lazydocker](https://github.com/jesseduffield/lazydocker) integrations

### Editor

- [Neovim](https://neovim.io/) with [LazyVim](https://www.lazyvim.org/) configuration

### Window Management

- [AeroSpace](https://github.com/nikitabobko/AeroSpace) tiling window manager
- [SketchyBar](https://github.com/FelixKratz/SketchyBar) status bar
- [Karabiner-Elements](https://karabiner-elements.pqrs.org/) keyboard customization
- [JankyBorders](https://github.com/FelixKratz/JankyBorders) window borders

### Utilities

- [eza](https://github.com/eza-community/eza) - modern `ls` replacement
- [bat](https://github.com/sharkdp/bat) - modern `cat` replacement
- [ripgrep](https://github.com/BurntSushi/ripgrep) - fast search
- [fd](https://github.com/sharkdp/fd) - fast `find` replacement
- [yazi](https://github.com/sxyazi/yazi) - terminal file manager
- [zoxide](https://github.com/ajeetdsouza/zoxide) - smarter `cd`

## Installation

### Prerequisites

Install Homebrew:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Setup

1. Clone the repository:

```bash
git clone https://github.com/willian/dotfiles.git ~/dotfiles
```

2. Install dependencies:

```bash
brew bundle --file=$HOME/dotfiles/Brewfile
```

3. Install dotfiles using rcm:

```bash
env RCRC=$HOME/dotfiles/rcrc rcup
```

This will symlink the configuration files to their appropriate locations.

## Key Bindings

### AeroSpace (Window Management)

**Navigation & Layout**

| Key | Action |
|-----|--------|
| `Alt + h/j/k/l` | Focus window left/down/up/right |
| `Alt + Shift + h/j/k/l` | Move window left/down/up/right |
| `Alt + 1-6` | Switch to workspace |
| `Alt + Shift + 1-6` | Move window to workspace and follow |
| `Alt + Tab` | Switch to last workspace |
| `Alt + Shift + Tab` | Move workspace to next monitor |
| `Alt + f` | Toggle fullscreen |
| `Alt + Shift + f` | Toggle floating/tiling |
| `Alt + /` | Toggle horizontal/vertical tiles |
| `Alt + ,` | Toggle horizontal/vertical accordion |
| `Alt + -` | Resize window smaller |
| `Alt + =` | Resize window larger |
| `Alt + Shift + 0` | Balance window sizes |

**App Launchers**

| Key | Action |
|-----|--------|
| `Alt + a` | ChatGPT |
| `Alt + b` | Zen Browser |
| `Alt + c` | Notion Calendar |
| `Alt + d` | Figma |
| `Alt + e` | Spark (email) |
| `Alt + m` | Spotify |
| `Alt + o` | OrbStack |
| `Alt + s` | Slack |
| `Alt + t` | WezTerm |
| `Alt + v` | Safari |
| `Alt + x` | X (Twitter) |
| `Alt + Ctrl + r` | Raycast |

**Database Management**

| Key | Action |
|-----|--------|
| `Ctrl + Shift + p` | Start PostgreSQL |
| `Ctrl + Shift + r` | Start Redis |
| `Alt + Ctrl + Shift + p` | Stop PostgreSQL |
| `Alt + Ctrl + Shift + r` | Stop Redis |

**Service Mode** (`Alt + Shift + ;` to enter)

| Key | Action |
|-----|--------|
| `Esc` | Reload config and exit service mode |
| `r` | Reset/flatten workspace layout |
| `f` | Toggle floating/tiling |
| `Backspace` | Close all windows but current |
| `Alt + Shift + h/j/k/l` | Join window with left/down/up/right |
| `Up/Down` | Volume up/down |
| `Shift + Down` | Mute |

### tmux

**General**

| Key | Action |
|-----|--------|
| `Ctrl + a` | Prefix (instead of Ctrl-b) |
| `Prefix + c` | New window (in current path) |
| `Prefix + \|` | Split pane horizontally |
| `Prefix + -` | Split pane vertically |
| `Prefix + x` | Kill pane (no confirmation) |
| `Prefix + m` | Toggle pane zoom |
| `Prefix + Q` | Kill current session |
| `Ctrl + h/j/k/l` | Navigate panes (vim-tmux-navigator) |

**Session Management (sesh)**

| Key | Action |
|-----|--------|
| `Prefix + K` | Session picker (fzf) |
| `Prefix + N` | Session UI popup |
| `Prefix + R` | Root session picker |
| `Prefix + L` | Switch to last session |
| `Prefix + 9` | Connect to root session |

**Integrations**

| Key | Action |
|-----|--------|
| `Prefix + g` | Open lazygit |
| `Prefix + d` | Open lazydocker |
| `Prefix + Y` | Run npm script (fzf) |
| `Prefix + u` | Open URLs (fzf-url) |

**Copy Mode** (vi keys)

| Key | Action |
|-----|--------|
| `v` | Begin selection |
| `y` | Copy selection |

### WezTerm

**Tmux Shortcuts** (Cmd sends to tmux prefix)

| Key | Action |
|-----|--------|
| `Cmd + 1-9` | Switch to tmux window 1-9 |
| `Cmd + t` | New tmux window |
| `Cmd + T` | Break pane to new window |
| `Cmd + n` | Split pane horizontally |
| `Cmd + N` | Split pane vertically |
| `Cmd + w` | Kill pane |
| `Cmd + k` | Session picker (sesh) |
| `Cmd + l` | Last session |
| `Cmd + g` | Open lazygit |
| `Cmd + d` | Open lazydocker |
| `Cmd + o` | Open URLs (fzf-url) |

**Neovim Shortcuts**

| Key | Action |
|-----|--------|
| `Cmd + s` | Save file |
| `Cmd + p` | Find files |
| `Cmd + f` | Live grep |
| `Cmd + R` | Source current file |

**Navigation**

| Key | Action |
|-----|--------|
| `Cmd + [` | Go back (Ctrl-o) |
| `Cmd + ]` | Go forward (Ctrl-i) |
| `Opt + Left` | Move word left |
| `Opt + Right` | Move word right |

## Directory Structure

```
dotfiles/
├── config/                  # XDG config files (~/.config/)
│   ├── aerospace/           # AeroSpace window manager
│   ├── bin/                 # Custom scripts
│   ├── borders/             # JankyBorders configuration
│   ├── eza/                 # eza theme
│   ├── fastfetch/           # fastfetch configuration
│   ├── karabiner/           # Karabiner-Elements keyboard remapping
│   ├── mise/                # mise runtime manager
│   ├── nvim/                # Neovim (LazyVim)
│   ├── opencode/            # OpenCode AI assistant
│   ├── sesh/                # sesh session manager
│   ├── sketchybar/          # SketchyBar status bar
│   ├── starship.toml        # Starship prompt
│   ├── tmux/                # tmux configuration
│   ├── wezterm/             # WezTerm terminal
│   ├── yazi/                # yazi file manager
│   └── zsh/                 # Zsh configs, functions, completions
├── hooks/                   # rcm hooks
│   ├── post-up/             # Scripts run after rcup
│   └── pre-up/              # Scripts run before rcup
├── Library/LaunchAgents/    # macOS launch agents
├── wallpapers/              # Desktop wallpapers
├── aliases                  # Shell aliases
├── Brewfile                 # Homebrew dependencies
├── default-gems             # Default Ruby gems (mise)
├── default-npm-packages     # Default npm packages (mise)
├── default-python-packages  # Default Python packages (mise)
├── gemrc                    # RubyGems configuration
├── gitconfig                # Git configuration
├── gitignore                # Global gitignore
├── gitmessage               # Git commit message template
├── psqlrc                   # PostgreSQL configuration
├── railsrc                  # Rails generator defaults
├── rcrc                     # rcm configuration
├── rspec                    # RSpec configuration
├── zimrc                    # Zim module configuration
└── zshrc                    # Zsh entry point
```

## Updating

Update Homebrew packages:

```bash
bup
```

## License

MIT
