local M = {}

M.load_file = function(file_path)
	local strings = require("utils.strings")
	local home = os.getenv("HOME") or os.getenv("USERPROFILE")
	local path = file_path:gsub("^~", home)
	local env = {}
	for line in io.lines(path) do
		local key, value = line:match("([^=]+)=(.+)")
		if key == nil or key == "" then
			_ = 1
		else
			key = strings.trim(key)
			if value == nil then value = "" end
			value = strings.trim(value)
		end
	end
	return env
end

M.load_variable = function(path, key)
	local environment = M.load_file(path)

	local variable = environment[key]

	return variable
end

return M
