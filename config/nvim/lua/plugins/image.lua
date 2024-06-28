return {
	"3rd/image.nvim",
	dependencies = { "luarocks.nvim" },
	config = function(_, opts)
		opts.integrations = {
			markdown = {
				only_render_image_at_cursor = true,
				resolve_image_path = function(document_path, image_path, fallback)
					local strings = require("utils.strings")
					local obsidian_vault = "/home/skela/Documents/notes/skela/"
					if strings.starts_with(document_path, obsidian_vault) then
						local document_name = strings.get_last_path_component(document_path)
						local assets =
							strings.replace(strings.replace(document_path, obsidian_vault, obsidian_vault .. "assets/"), document_name, "_resources/" .. document_name)
						local res = strings.replace(assets, ".md", ".resources/")
						local photo = res .. image_path
						return photo
					end
					return fallback(document_path, image_path)
				end,
			},
		}

		require("image").setup(opts)
	end,
}
