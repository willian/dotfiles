require("sex").setup()
require("fzf-url").setup()

local terminal = "com.superlogical.terminal"

-- The focused pane's directory: what its shell last reported, else where its
-- foreground process runs.
local function cwd(ctx)
  local p = rex.block.call(terminal, "pwd", { block_id = ctx.block_id })
  if p and p.pwd then
    return p.pwd
  end
  local proc = rex.block.call(terminal, "process", { block_id = ctx.block_id })
  return proc and proc.foreground and proc.foreground.cwd
end

-- Opens a floating pane running cmd in the focused pane's directory, centered
-- 95%x95% unless bounds ({ x, y, w, h } window fractions) says otherwise. The
-- pane closes when cmd exits.
local function popup(name, title, cmd, bounds)
  rex.action({
    name = name,
    title = title,
    run = function(ctx)
      local _, err = rex.session.new_layer({
        bounds = bounds or { 0.025, 0.025, 0.95, 0.95 },
        focus = true,
        layout = rex.layout.block({
          flavor = terminal .. ".shell",
          options = { command = cmd, cwd = cwd(ctx) },
        }),
      })
      if err then
        error(err, 0)
      end
    end,
  })
end

popup("lazygit", "Open lazygit", { "lazygit" })
popup("lazydocker", "Open lazydocker", { "lazydocker" })
popup("gh_dash", "Open gh dash", { "mise", "exec", "--", "gh", "dash" })

-- Worktrees, as tmux's prefix S/D/C popups
local bin = os.getenv("HOME") .. "/.config/bin/"
local mid = { 0.15, 0.2, 0.7, 0.6 }
popup("t", "Pick session or worktree", { bin .. "t" }, mid)
popup("wt_pick", "Pick or create worktree", { "mise", "exec", "--", bin .. "wt-pick" }, mid)
popup("wt_remove", "Remove worktrees", { "mise", "exec", "--", bin .. "wt-remove" }, mid)
popup(
  "wt_prune",
  "Remove merged worktrees",
  { "sh", "-c", "mise exec -- wt step prune --foreground; printf 'Done. Press Enter.'; read _" },
  { 0.25, 0.25, 0.5, 0.5 }
)

-- Types text into the focused pane, like Ghostty's `text:` keybinds.
local function send(text)
  return function(ctx)
    rex.block.call(terminal, "write", { block_id = ctx.block_id, data = text })
    return true
  end
end

-- Panes
rex.bind("cmd+n", "pane.split.right")
rex.bind("cmd+shift+n", "pane.split.down")

-- Tools
rex.bind("cmd+g", "lazygit")
rex.bind("cmd+shift+g", "gh_dash")
rex.bind("cmd+d", "lazydocker")
rex.bind("cmd+o", "fzf_url")

-- Worktrees
rex.bind("cmd+shift+s", "wt_pick")
rex.bind("cmd+shift+d", "wt_remove")
rex.bind("cmd+shift+c", "wt_prune")

-- Sessions
rex.bind("cmd+k", "t")
rex.bind("cmd+l", "sex_last")

-- Neovim
rex.bind("cmd+shift+f", send("\27 sg\n")) -- live grep
rex.bind("cmd+p", send("\27 ff\n")) -- find files
rex.bind("cmd+s", send("\27:w\n")) -- save
