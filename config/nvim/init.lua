
vim.wo.relativenumber = true
vim.g.python_recommended_style = 0
vim.o.expandtab = false
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smartindent = true

if os.getenv("HOME"):find("/Users/",1,true) == 1 then
	local sdk = "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
	vim.env.C_INCLUDE_PATH = sdk .. "/usr/include/"
	vim.env.SDKROOT = sdk
end

-- local toggleterm = require("custom.configs.toggleterm")
-- vim.api.nvim_create_user_command("OpenTerm1", function() toggleterm.open_term1() end,{})
-- vim.api.nvim_create_user_command("OpenTerm2", function() toggleterm.open_term2() end,{})
-- vim.api.nvim_create_user_command("OpenTerm3", function() toggleterm.open_term3() end,{})

