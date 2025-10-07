---@class Object
---@field isMoving boolean
---@field x number
---@field y number
---@field width number
---@field height number
Object = {}
Object.__index = Object

function Object:new()
	local object = setmetatable({}, Object)
	return object
end
function Object:load() end

function Object:update(dt) end
function Object:draw() end

function Object:move(x, y)
	if self.isMoving == true then
		self.x = x
		self.y = y
	end
end

function Object:isInBox(x, y, maxHeight)
	local minX = self.x
	local maxX = self.x + self.width
	local clickableY = self:getClickableY(maxHeight)
	if x > minX and x < maxX then
		if y > clickableY.topY and y < clickableY.maxY then
			return true
		else
			return false
		end
	else
		return false
	end
end

function Object:getClickableY(maxHeight)
	local topY = self.y
	local maxY = topY + (maxHeight or (self.height + (self.height / 2)))
	return { topY = topY, maxY = maxY }
end

function Object:setMoving(x, y, maxHeight)
	local clickableY = self:getClickableY()
	if y < clickableY.topY then
		self.isMoving = false
		return
	end
	if self:isInBox(x, y, maxHeight) == true then
		self.startX = self.x
		self.startY = self.y
		self.isMoving = true
	else
		self.isMoving = false
	end
end
