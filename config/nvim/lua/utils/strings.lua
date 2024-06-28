local M = {}

M.trim = function(s) return (string.gsub(s, "^%s*(.-)%s*$", "%1")) end

M.starts_with = function(str, start) return string.sub(str, 1, string.len(start)) == start end

M.replace = function(str, old, new) return string.gsub(str, old, new) end

M.get_last_path_component = function(path) return path:match("([^/\\]+)$") end

return M
