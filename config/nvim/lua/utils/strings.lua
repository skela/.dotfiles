local M = {}

M.trim = function(s) return (string.gsub(s, "^%s*(.-)%s*$", "%1")) end

return M
