local utils = {}

function utils.require_safely(module_name)
	local status_ok, module = pcall(require,module_name)
	if not status_ok then
		vim.notify("Error requiring " .. module_name)
		return
	end
	return module
end

function utils.has_module(module_name)
	local status_ok, _ = pcall(require,module_name)
	if not status_ok then
		return false
	end
	return true
end

return utils
