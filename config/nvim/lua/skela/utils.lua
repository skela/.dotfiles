local utils = {}

function utils.require_safely(module_name)
	local status_ok, module = pcall(require,module_name)
	if not status_ok then
		vim.notify("Error requiring " .. module_name)
		return
	end
	return module
end

return utils
