return {
	{
		"mistweaverco/kulala.nvim",
		ft = "http",
		keys = {
			{ "<leader>r", "", desc = "+Rest" },
			{ "<leader>rr", "<cmd>lua require('kulala').run()<cr>", desc = "Send the request" },
			{ "<leader>rt", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Toggle headers/body" },
			{ "<leader>rp", "<cmd>lua require('kulala').jump_prev()<cr>", desc = "Jump to previous request" },
			{ "<leader>rn", "<cmd>lua require('kulala').jump_next()<cr>", desc = "Jump to next request" },
			{ "<leader>rc", "<cmd>lua require('kulala').copy()<cr>", desc = "Copy request as curl" },
			{ "<leader>ri", "<cmd>lua require('kulala').from_curl()<cr>", desc = "Run curl from clipboard" },
			{ "<leader>ro", "<cmd>lua require('utils.ui').open_last_request()<cr>", desc = "Open last http request (response)" },
			{ "<leader>rs", "<cmd>lua require('kulala').search()<cr>", desc = "Search current directory" },
			{ "<leader>rS", "<cmd>lua require('kulala').scratchpad()<cr>", desc = "Open Scratchpad" },
			{
				"<leader>re",
				"<cmd>lua require('kulala').set_selected_env()<cr>",
				desc = "Select environment for http request",
			},
		},
		opts = {
			default_winbar_panes = { "body", "headers", "headers_body", "script_output" },
			winbar = true,
			default_env = "prod",
			default_view = "headers_body",
		},
		config = function(_, opts)
			require("kulala").setup(opts)
			-- require("kulala.api").on("after_request", function(data)
			-- 	local success, parsed_json = pcall(vim.fn.json_decode, data.body)
			--
			-- 	local body_to_display
			-- 	if success then
			-- 		body_to_display = require("utils.ui").pretty_print_json(parsed_json)
			-- 	else
			-- 		body_to_display = data.body
			-- 	end
			--
			-- 	require("utils.ui").set_last_response(body_to_display)
			--
			-- 	require("utils.ui").create_floating_window(body_to_display)
			-- end)
		end,
	},
}
