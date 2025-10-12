require("engine/base")
---@class Object: Base
---@field x number
---@field y number
---@field width number
---@field height number
Object = Base:extend()

function Object:init()
	self:new()
end
function Object:new()
	self.isMoving = false
	self.x = 0
	self.y = 0
	self.width = 0
	self.height = 0
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

function Object:getBoundingBox()
	return {
		minX = self.x,
		maxX = self.x + self.width,
		minY = self.y,
		maxY = self.y + self.height,
	}
end

function Object:isInBox(x, y, maxHeight)
	local box = self:getBoundingBox()
	if maxHeight then
		box.maxY = box.minY + maxHeight
	end

	local inX = x > box.minX and x < box.maxX
	local inY = y > box.minY and y < box.maxY
	return inX and inY
end

function Object:setMoving(x, y, maxHeight)
	local topY = self.y
	if y < topY then
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
