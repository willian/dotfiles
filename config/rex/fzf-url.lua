-- Port of tmux-fzf-url (https://github.com/joshmedeski/tmux-fzf-url) for Rex.
-- Picks URLs visible in the focused pane in fzf and opens the chosen ones.
--
--   require("fzf-url").setup()
--   rex.bind("cmd+o", "fzf_url")

local M = {}

local terminal = "com.superlogical.terminal"
local MAX = 983040 -- the most `format` returns per call

-- The text on the pane's screen: its last `rows` lines, with rows the terminal
-- wrapped joined back so long URLs stay whole.
-- ponytail: assumes the pane is scrolled to the bottom; scrolled-up views show
-- the bottom screen's URLs instead.
local function screen(block_id)
  local size, err = rex.block.call(terminal, "size", { block_id = block_id })
  if err then
    error(err, 0)
  end
  local out, ferr = rex.block.call(terminal, "format", { block_id = block_id, max_bytes = MAX })
  if ferr then
    error(ferr, 0)
  end
  local text = out.content
  if out.id and out.total > MAX then
    local rest = rex.block.call(terminal, "blob_read", { block_id = block_id, id = out.id, offset = out.total - MAX })
    text = rest and rest.content or text
  end

  local lines = {}
  for line in (text .. "\n"):gmatch("(.-)\n") do
    lines[#lines + 1] = line
  end
  local parts = {}
  for i = math.max(1, #lines - size.rows + 1), #lines do
    parts[#parts + 1] = lines[i]
    if #lines[i] < size.columns then
      parts[#parts + 1] = "\n"
    end
  end
  return table.concat(parts)
end

-- Runs in the popup with the screen text as $1 and fzf options after it. The
-- extractors are joshmedeski/tmux-fzf-url's: URLs, www. domains, IPs, git
-- remotes, quoted "owner/repo" (lazy.nvim plugin specs) as GitHub links, and
-- `import ... "pkg"` as npm links.
local script = [=[
content=$1; shift
urls=$(echo "$content" | grep -oE '(https?|ftp|file):/?//[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]')
wwws=$(echo "$content" | grep -oE '(http?s://)?www\.[a-zA-Z](-?[a-zA-Z0-9])+\.[a-zA-Z]{2,}(/\S+)*' | grep -vE '^https?://' | sed 's/^\(.*\)$/http:\/\/\1/')
ips=$(echo "$content" | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(:[0-9]{1,5})?(/\S+)*' | sed 's/^\(.*\)$/http:\/\/\1/')
gits=$(echo "$content" | grep -oE '(ssh://)?git@\S*' | sed 's/:/\//g' | sed 's/^\(ssh\/\/\/\)\{0,1\}git@\(.*\)$/https:\/\/\2/')
gh=$(echo "$content" | grep -oE "['\"]([A-Za-z0-9-]*/[.A-Za-z0-9-]*)['\"]" | sed "s/['\"]//g" | sed 's#.#https://github.com/&#')
npm=$(echo "$content" | grep -oE "import\s+[^\"';]*[\"']([^.][^\"';]*)[\"']" | sed "s/[^'\"]*['\"]\([^'\"]*\)['\"];*/\1/" | sed 's@.@https:\/\/npmjs.com\/package\/&@')
items=$(printf '%s\n' "$urls" "$wwws" "$gh" "$npm" "$ips" "$gits" | grep -v '^$' | sort -u)
if [ -z "$items" ]; then echo "No URLs found"; sleep 1; exit; fi
printf '%s\n' "$items" | fzf --multi "$@" | while IFS= read -r u; do open "$u"; done
]=]

-- opts.bounds: popup { x, y, w, h } as window fractions.
-- opts.fzf_args: extra fzf arguments.
function M.setup(opts)
  opts = opts or {}
  local bounds = opts.bounds or { 0.2, 0.35, 0.6, 0.3 }
  local fzf_args = opts.fzf_args or { "--prompt=\239\130\142   ", "--border-label= Open URL " }

  rex.action({
    name = "fzf_url",
    title = "Open URL",
    run = function(ctx)
      -- The text goes in as an argument, so nothing on screen is run.
      local cmd = { "bash", "-c", script, "bash", screen(ctx.block_id) }
      for _, a in ipairs(fzf_args) do
        cmd[#cmd + 1] = a
      end

      local _, err = rex.session.new_layer({
        bounds = bounds,
        focus = true,
        layout = rex.layout.block({ flavor = terminal .. ".shell", options = { command = cmd } }),
      })
      if err then
        error(err, 0)
      end
    end,
  })
end

return M
