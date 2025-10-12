local Utils = {}
Utils.__index = Utils

function Utils:getBoundingBox(x, y, width, height)
	local halfWidth = width / 2
	local halfHeight = height / 2
	return { minX = x - halfWidth, maxX = x + halfWidth, minY = y - halfHeight, maxY = y + halfHeight }
end

function Utils:isEmpty(table)
	return #table == 0
end

function Utils:map(list, fun)
	local newList = {}
	for i, value in ipairs(list) do
		newList[i] = fun(value)
	end
	return newList
end

function Utils:getIndex(table, value)
	local resultIndex = nil
	for index, currentValue in ipairs(table) do
		if value == currentValue then
			resultIndex = index
		end
	end
	return resultIndex
end

return Utils
