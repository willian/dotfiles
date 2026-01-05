return {
  {
    "vuki656/package-info.nvim",
    ft = "json",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
      { "<leader>cnt", "<cmd>lua require('package-info').toggle()<CR>", desc = "Toggle" },
      { "<leader>cnd", "<cmd>lua require('package-info').delete()<CR>", desc = "Delete package" },
      { "<leader>cnu", "<cmd>lua require('package-info').update()<CR>", desc = "Update package" },
      { "<leader>cni", "<cmd>lua require('package-info').install()<CR>", desc = "Install a new package" },
      { "<leader>cnc", "<cmd>lua require('package-info').change_version()<CR>", desc = "Change package version" },
    },
    opts = {
      hide_unstable_versions = true,
      hide_up_to_date = true,
      package_manager = "npm",
    },
  },
}
