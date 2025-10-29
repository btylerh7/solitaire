local class = require("engine.class")

---@class Box
---@field x number
---@field y number
---@field width number
---@field height number
local Box = class.new("Box")

function Box:new(x, y, width, height)
	local box = setmetatable({}, self)
	box.x = x
	box.y = y
	box.width = width
	box.height = height
	return box
end

function Box:getBoundingRect()
	return {
		x1 = self.x,
		x2 = self.x + self.width,
		y1 = self.y,
		y2 = self.y + self.height,
	}
end

---@param maxHeight? number
function Box:getClickableRange(maxHeight)
	local boundingRect = self:getBoundingRect()
	if maxHeight then
		boundingRect.y2 = boundingRect.y1 + maxHeight
	end
	return boundingRect
end

---@param x number
---@param y number
---@param maxHeight? number
function Box:checkInBox(x, y, maxHeight)
	local boundingRect = self:getClickableRange(maxHeight)
	return x > boundingRect.x1 and x < boundingRect.x2 and y > boundingRect.y1 and y < boundingRect.y2
end

return Box
