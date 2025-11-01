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
---@param fn fun(item: T, index?: number): any
forEach = function(list, fn)
	for currIndex, value in ipairs(list) do
		fn(value, currIndex)
	end
end

---@generic T
---@param list T[]
---@param fn fun(item: T, index?: number): any
---@return any[]
map = function(list, fn)
	local result = {}
	for currIndex, value in ipairs(list) do
		local newValue = fn(value, currIndex)
		table.insert(result, newValue)
	end
	return result
end

---@generic T
---@param list T[]
---@param fn fun(item: T): boolean
---@return T, number | nil
find = function(list, fn)
	for index, value in ipairs(list) do
		if fn(value) == true then
			return value, index
		end
	end
	return nil
end
