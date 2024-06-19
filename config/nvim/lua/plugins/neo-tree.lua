return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    local events = require("neo-tree.events")

    opts.event_handlers = {
      {
        event = events.FILE_OPENED,
        handler = function()
          -- auto close
          require("neo-tree.command").execute({ action = "close" })
        end,
      },
    }
  end,
}
