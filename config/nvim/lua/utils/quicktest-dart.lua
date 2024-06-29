local Job = require("plenary.job")

local function find_project_directory(filepath)
	local function file_exists(path)
		local file = io.open(path, "r")
		if file then
			file:close()
			return true
		else
			return false
		end
	end

	local function find_pubspec_yaml(dir)
		local parent_dir = vim.fn.fnamemodify(dir, ":h")
		local pubspec_path = parent_dir .. "/pubspec.yaml"
		if file_exists(pubspec_path) then
			return parent_dir
		elseif parent_dir ~= dir then
			return find_pubspec_yaml(parent_dir)
		else
			return nil
		end
	end

	return find_pubspec_yaml(vim.fn.expand(filepath))
end

local function ltrim(s) return s:gsub("^%s*", "") end

local function get_nearest_test(bufnr, cursor_pos)
	local function clean_name(s)
		local extracted = s:match('"([^"]+)"')
		if extracted then return extracted end
		return ""
	end
	for pos = cursor_pos[1], 1, -1 do
		local aline = vim.api.nvim_buf_get_lines(bufnr, pos - 1, pos, true)[1]
		local line = ltrim(aline)
		if vim.startswith(line, "test(") or vim.startswith(line, "group(") then return clean_name(line) end
	end
	return ""
end

local M = {
	name = "dart",
}
---@class DartRunParams
---@field func_name? string
---@field bufnr integer
---@field cursor_pos integer[]
---@field path string
---@field cwd? string

---@param bufnr integer
---@param cursor_pos integer[]
---@return DartRunParams | nil, nil | string
M.build_line_run_params = function(bufnr, cursor_pos)
	local filepath = vim.api.nvim_buf_get_name(bufnr)

	local testname = get_nearest_test(bufnr, cursor_pos)
	if #testname == 0 then return nil, "No test to run" end

	return {
		bufnr = bufnr,
		cursor_pos = cursor_pos,
		func_name = testname,
		path = filepath,
	}, nil
end

---@param bufnr integer
---@param cursor_pos integer[]
---@return DartRunParams, nil | string
M.build_file_run_params = function(bufnr, cursor_pos)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	return {
		bufnr = bufnr,
		cursor_pos = cursor_pos,
		path = filepath,
	}, nil
end

---@param bufnr integer
---@param cursor_pos integer[]
---@return DartRunParams, nil | string
M.build_dir_run_params = function(bufnr, cursor_pos)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	local folder = vim.fn.fnamemodify(filepath, ":h")
	return {
		bufnr = bufnr,
		cursor_pos = cursor_pos,
		path = folder,
	}, nil
end

---@param bufnr integer
---@param cursor_pos integer[]
---@return DartRunParams | nil, nil | string
M.build_all_run_params = function(bufnr, cursor_pos)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	local pwd = find_project_directory(filepath)
	if pwd == nil then return nil, "Unable to locate project directory, could not find pubspec.yaml" end
	return {
		bufnr = bufnr,
		cursor_pos = cursor_pos,
		path = "",
		cwd = pwd,
	}, nil
end

---@param params DartRunParams
---@param send fun(data: any)
---@return integer
M.run = function(params, send)
	local args = {}
	table.insert(args, "test")
	if #params.path > 0 then table.insert(args, params.path) end
	if params.func_name and #params.func_name > 0 then table.insert(args, "--plain-name=" .. params.func_name) end
	table.insert(args, "-r")
	table.insert(args, "github")

	local job = Job:new({
		command = "flutter",
		args = args,
		cwd = params.cwd,
		on_stdout = function(_, data) send({ type = "stdout", raw = data, output = data }) end,
		on_stderr = function(_, data) send({ type = "stderr", rwa = data, output = data }) end,
		on_exit = function(_, return_val) send({ type = "exit", code = return_val }) end,
	})

	job:start()

	---@type integer
	---@diagnostic disable-next-line: assign-type-mismatch
	local pid = job.pid

	return pid
end

---@param params DartRunParams
M.title = function(params)
	local test_name = ""
	if params.func_name and #params.func_name > 0 then test_name = params.func_name end
	if #test_name == 0 then return params.path end
	return params.path .. " - " .. test_name
end

---@param bufnr integer
---@return boolean
M.is_enabled = function(bufnr)
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	return vim.endswith(bufname, "_test.dart")
end

return M
