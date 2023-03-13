local utils = require("skela.utils")
local treesitter = utils.require_safely("nvim-treesitter.configs")
if not treesitter then return end

treesitter.setup
{
  ensure_installed = { "c", "lua", "rust", "python", "dart", "yaml", "json", "bash", "kotlin", "swift", "fish", "ruby", "markdown" },
  sync_install = false,
  auto_install = true,
  ignore_install = { "javascript" },
  highlight = {
		enable = true,
    disable = { "c" },
    additional_vim_regex_highlighting = false,
  },
}
