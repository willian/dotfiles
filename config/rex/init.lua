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

-- Opens a centered 95%x95% floating pane running cmd in the focused pane's directory.
-- The pane closes when cmd exits.
local function popup(name, title, cmd)
  rex.action({
    name = name,
    title = title,
    run = function(ctx)
      local _, err = rex.session.new_layer({
        bounds = { 0.025, 0.025, 0.95, 0.95 },
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

-- Sessions
rex.bind("cmd+k", "sex_pick")
rex.bind("cmd+l", "sex_last")

-- Neovim
rex.bind("cmd+shift+f", send("\27 sg\n")) -- live grep
rex.bind("cmd+p", send("\27 ff\n")) -- find files
rex.bind("cmd+s", send("\27:w\n")) -- save
