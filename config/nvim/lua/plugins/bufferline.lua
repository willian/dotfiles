-- Temp fix for the buffline integration
-- TODO: Remove this when https://github.com/LazyVim/LazyVim/pull/6354 gets merged
return {
  "akinsho/bufferline.nvim",
  init = function()
    local bufline = require("catppuccin.groups.integrations.bufferline")
    function bufline.get()
      return bufline.get_theme()
    end
  end,
}
