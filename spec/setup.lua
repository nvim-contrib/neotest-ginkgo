-- Test setup configuration
-- Update the paths below to match your local installations of the plugins

vim.opt.rtp:append(".")

local function add_plugin(path)
  local expanded = vim.fn.expand(path)
  if vim.fn.isdirectory(expanded) == 1 then
    vim.opt.rtp:append(expanded)
  end
end

add_plugin("~/.local/share/nvim/lazy/nvim-nio")
add_plugin("~/.local/share/nvim/lazy/nvim-treesitter")
add_plugin("~/.local/share/nvim/lazy/plenary.nvim")
add_plugin("~/.local/share/nvim/lazy/neotest")

vim.cmd.runtime({ "plugin/plenary.vim", bang = true })

require("neotest").setup({
	log_level = vim.log.levels.WARN,
})
