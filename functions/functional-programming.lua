---@generic T
---@param list T[]
---@param fn fun(item: T): boolean
---@return T[]
filter = function(list, fn)
	local result = {}
	for _, value in ipairs(list) do
		if fn(value) then
			table.insert(result, value)
		end
	end
	return result
end

---@generic T
---@param list T[]
---@param fn fun(item: T)
forEach = function(list, fn)
	for _, value in ipairs(list) do
		fn(value)
	end
end

---@generic T
---@param list T[]
---@param fn fun(item: T): any
---@return any[]
map = function(list, fn)
	local result = {}
	for _, value in ipairs(list) do
		local newValue = fn(value)
		table.insert(result, newValue)
	end
	return result
end

---@generic T
---@param list T[]
---@param fn fun(item: T): boolean
---@return T | nil
find = function(list, fn)
	for _, value in ipairs(list) do
		if fn(value) == true then
			return value
		end
	end
	return nil
end
