---@class Box:Base
Box = Base:extend()

function Box:new(x, y, width, height)
	self.width = width
	self.height = height
	self:setPosition(x, y)
	return self
end

function Box:setPosition(x, y)
	self.position = { x = x, y = y }
	self.maxX = x + self.width
	self.maxY = y + self.height
end
function Box:isInBox(x, y, maxHeight)
	local minX = self.position.x
	local maxX = self.maxX
	local minY = self.position.y
	local maxY = 0
	if maxHeight then
		maxY = maxHeight + self.position.y
	else
		maxY = self.maxY
	end
	local inX = x > minX and x < maxX
	local inY = y > minY and y < maxY

	return inX == true and inY == true
end
