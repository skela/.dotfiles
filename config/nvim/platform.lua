T = {}

T.is_mac = function()
	if os.getenv("HOME"):find("/Users/",1,true) == 1 then
		return true
	else
		return false
	end
end

return T
