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
	local halfWidth = self.width / 2
	local halfHeight = self.height / 2
	local minX = self.x - halfWidth
	local maxX = self.x + halfWidth
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
	local halfHeight = self.height / 2
	local topY = self.y - halfHeight
	local maxY = self.y + halfHeight
	if not maxHeight == nil then
		maxY = topY + maxHeight
	end

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
