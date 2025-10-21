switch = function(value, cases, defaultFunc)
	local func = cases[value]
	if func then
		return func()
	end
	if defaultFunc then
		return defaultFunc()
	end
	return nil
end
