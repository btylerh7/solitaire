local Utils = {}
Utils.__index = Utils

function Utils:getBoundingBox(x, y, width, height)
	local halfWidth = width / 2
	local halfHeight = height / 2
	return { minX = x - halfWidth, maxX = x + halfWidth, minY = y - halfHeight, maxY = y + halfHeight }
end

return Utils
